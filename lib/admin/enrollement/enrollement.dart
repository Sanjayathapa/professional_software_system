import 'package:ciheapp/provider/api/enrollementprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrollmentScreen extends StatelessWidget {
  EnrollmentScreen({Key? key}) : super(key: key);

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<EnrollmentProvider>(context, listen: false)
        .fetchEnrollments();
  }

  void _showEditDialog(BuildContext context, String id, String currentStatus) {
    String selectedStatus =
        currentStatus == "approved" ? "approved" : "pending";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Enrollment Status'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: "approved", child: Text("Approved")),
                  DropdownMenuItem(value: "pending", child: Text("Pending")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<EnrollmentProvider>(context, listen: false)
                    .updateEnrollmentStatus(context, id, selectedStatus);

                _refreshData(context);
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => EnrollmentProvider()..fetchEnrollments(),
        child: Consumer<EnrollmentProvider>(
          builder: (context, enrollmentProvider, child) {
            if (enrollmentProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (enrollmentProvider.errorMessage != null) {
              return Center(
                child: Text(
                  enrollmentProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: enrollmentProvider.enrollments.length,
                itemBuilder: (context, index) {
                  final enrollment = enrollmentProvider.enrollments[index];

                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course and Student Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                enrollment.courseName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Student: ${enrollment.studentName}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 119, 156),
                                ),
                              ),
                            ],
                          ),
                        ),

                      
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Chip(
                              label: Text(
                                enrollment.status,
                                style: TextStyle(
                                  color: enrollment.status == 'pending'
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                _showEditDialog(
                                  context,
                                  enrollment.id.toString(),
                                  enrollment.status,
                                );
                              },
                              child: const Icon(Icons.edit,
                                  size: 20, color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
