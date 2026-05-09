
import 'package:flutter/material.dart';
import 'package:principles_ss/model/assignment.dart';
import 'package:principles_ss/provider/api/apiassignmentprovider.dart';
import 'package:principles_ss/teacher/assignmentapi/create_assignments.dart';
import 'package:principles_ss/teacher/assignmentapi/editassignments.dart';
import 'package:provider/provider.dart';

class TeacherAssignmentList extends StatefulWidget {
  const TeacherAssignmentList({Key? key}) : super(key: key);

  @override
  State<TeacherAssignmentList> createState() => _TeacherAssignmentListState();
}

class _TeacherAssignmentListState extends State<TeacherAssignmentList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadAssignments();
    });
  }

  Future<void> _loadAssignments() async {
    final assignmentProvider =
        Provider.of<AssignmentsProvider>(context, listen: false);
    await assignmentProvider.fetchAssignments();
  }

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = Provider.of<AssignmentsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: assignmentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAssignments,
              child: assignmentProvider.assignments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.assignment,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No assignments found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: assignmentProvider.assignments.length,
                      itemBuilder: (context, index) {
                        final assignment =
                            assignmentProvider.assignments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 0),
                          child: ListTile(
                            leading:
                                _getAssignmentStatusIcon(assignment.status),
                            title: Text(assignment.title,style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 1, 135, 53)),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(assignment.courseName),
                                const SizedBox(height: 4),
                                 Text(assignment.description,style: TextStyle(color: const Color.fromARGB(255, 10, 1, 135))),
                                Text(
                                  'Due: ${_formatDate(assignment.dueDate)}',
                                  style: TextStyle(
                                    color: _getDueDateColor(assignment.dueDate),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${assignment.totalPoints} pts',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Update Assignment'),
                                ),
                                
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                  EditAssignment(
                                    assignmentId: assignment.id,
                                    courseId: assignment.courseId,
                                    title: assignment.title,
                                    description: assignment.description,
                                    link: assignment.links,
                                    dueDate: assignment.dueDate,
                                  )));
                                }  else if (value == 'delete') {
                                  _showDeleteConfirmationDialog(assignment);
                                }
                              },
                            ),
                            onTap: () {

                            },
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAssignment(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getAssignmentStatusIcon(AssignmentStatus status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case AssignmentStatus.pending:
        iconData = Icons.assignment_outlined;
        iconColor = Colors.blue;
        break;
      case AssignmentStatus.submitted:
        iconData = Icons.assignment_turned_in_outlined;
        iconColor = Colors.orange;
        break;
      case AssignmentStatus.late:
        iconData = Icons.assignment_late_outlined;
        iconColor = Colors.red;
        break;
      case AssignmentStatus.graded:
        iconData = Icons.grading;
        iconColor = Colors.green;
        break;
      case AssignmentStatus.returned:
        iconData = Icons.assignment_return_outlined;
        iconColor = Colors.purple;
        break;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return Colors.red;
    } else if (difference <= 2) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Future<void> _showDeleteConfirmationDialog(Assignments assignment) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete assignment'),
          content: Text('Are you sure you want to delete '),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteAssignment(assignment.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAssignment(int id) async {
    final assignmentprovider =
        Provider.of<AssignmentsProvider>(context, listen: false);
    try {
      await assignmentprovider.deleteAssignment(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Assignment deleted successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to delete Assignment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }
}
