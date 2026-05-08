
import 'package:ciheapp/model/assignment.dart';
import 'package:ciheapp/provider/assignment.dart';
import 'package:ciheapp/view/assignments/assignments_submission.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AssignmentDetailScreen extends StatefulWidget {
  final String assignmentId;

  const AssignmentDetailScreen({
    Key? key,
    required this.assignmentId,
  }) : super(key: key);

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssignment();
    });
  }

  Future<void> _loadAssignment() async {
    final assignmentProvider =
        Provider.of<AssignmentProvider>(context, listen: false);
    await assignmentProvider.fetchAssignmentById(widget.assignmentId);
  }

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    final assignment = assignmentProvider.selectedAssignment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
      ),
      body: assignmentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : assignment == null
              ? const Center(child: Text('Assignment not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _getAssignmentStatusIcon(assignment.status),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          assignment.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          assignment.courseName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Due Date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDate(assignment.dueDate),
                                        style: TextStyle(
                                          color: _getDueDateColor(
                                              assignment.dueDate),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Points',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        assignment.status ==
                                                AssignmentStatus.graded
                                            ? '${assignment.earnedPoints}/${assignment.totalPoints}'
                                            : '${assignment.totalPoints} points',
                                        style: TextStyle(
                                          color: assignment.status ==
                                                  AssignmentStatus.graded
                                              ? Colors.green
                                              : null,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Assignment description
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(assignment.description),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Submission status
                      if (assignment.status == AssignmentStatus.submitted ||
                          assignment.status == AssignmentStatus.graded)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Submission',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Submitted on: ${_formatDate(assignment.submissionDate!)}',
                                    ),
                                  ],
                                ),
                                if (assignment.submissionUrl != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_file, size: 16),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {
                                          // Open submission file
                                        },
                                        child: const Text('View Submission'),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                      // Feedback
                      if (assignment.status == AssignmentStatus.graded &&
                          assignment.feedback != null)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Feedback',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(assignment.feedback!),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Action button
                      if (assignment.status == AssignmentStatus.pending ||
                          assignment.status == AssignmentStatus.late)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AssignmentSubmissionScreen(
                                    assignmentId: assignment.id,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Submit Assignment'),
                          ),
                        ),
                    ],
                  ),
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
      radius: 24,
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
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
