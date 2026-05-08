
import 'package:ciheapp/model/assignment.dart';
import 'package:ciheapp/provider/assignment.dart';
import 'package:ciheapp/view/assignments/assignments_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadAssignments();
    });
    
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadAssignments() async {
    final assignmentProvider = Provider.of<AssignmentProvider>(context, listen: false);
    await assignmentProvider.fetchAssignments();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
     body: Column(
      children: [
       
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: const Color.fromARGB(255, 249, 185, 49),
                borderRadius: BorderRadius.circular(8),
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Submitted'),
                Tab(text: 'Late'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAssignmentList(AssignmentStatus.pending),
              _buildSubmittedAssignmentsList(),
              _buildAssignmentList(AssignmentStatus.late),
            ],
          ),
        ),
      ],
    ),
    );
  }
  
  Widget _buildAssignmentList(AssignmentStatus status) {
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    
    List<Assignment> assignments;
    if (status == AssignmentStatus.pending) {
      assignments = assignmentProvider.pendingAssignments;
    } else if (status == AssignmentStatus.late) {
      assignments = assignmentProvider.lateAssignments;
    } else {
      assignments = [];
    }
    
    if (assignmentProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (assignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              status == AssignmentStatus.pending
                  ? 'No pending assignments'
                  : 'No late assignments',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadAssignments,
      child: ListView.builder(
        itemCount: assignments.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ListTile(
              leading: _getAssignmentStatusIcon(assignment.status),
              title: Text(assignment.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assignment.courseName),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${_formatDate(assignment.dueDate)}',
                    style: TextStyle(
                      color: _getDueDateColor(assignment.dueDate),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: Text(
                '${assignment.totalPoints} pts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignmentDetailScreen(assignmentId: assignment.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSubmittedAssignmentsList() {
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    final assignments = assignmentProvider.submittedAssignments;
    
    if (assignmentProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (assignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_turned_in_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No submitted assignments',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadAssignments,
      child: ListView.builder(
        itemCount: assignments.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ListTile(
              leading: _getAssignmentStatusIcon(assignment.status),
              title: Text(assignment.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assignment.courseName),
                  const SizedBox(height: 4),
                  Text(
                    assignment.status == AssignmentStatus.graded
                        ? 'Grade: ${assignment.earnedPoints}/${assignment.totalPoints}'
                        : 'Submitted: ${_formatDate(assignment.submissionDate!)}',
                    style: TextStyle(
                      color: assignment.status == AssignmentStatus.graded
                          ? Colors.green
                          : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: assignment.status == AssignmentStatus.graded
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.hourglass_bottom,
                      color: Colors.orange,
                    ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignmentDetailScreen(assignmentId: assignment.id),
                  ),
                );
              },
            ),
          );
        },
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
}

