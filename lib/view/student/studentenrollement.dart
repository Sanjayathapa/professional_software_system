import 'package:ciheapp/admin/course/addcourse.dart';
import 'package:ciheapp/provider/api/enrollementprovider.dart';
import 'package:ciheapp/view/student/addenrollement.dart';
import 'package:ciheapp/view/student/updateenrollement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentEnrollmentScreen extends StatefulWidget {
  const StudentEnrollmentScreen({Key? key}) : super(key: key);
  

  @override
  State<StudentEnrollmentScreen> createState() => _StudentEnrollmentScreenState();
}

class _StudentEnrollmentScreenState extends State<StudentEnrollmentScreen> {
  @override
  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<EnrollmentProvider>(context, listen: false)
        .fetchEnrollments();
  }
  Widget build(BuildContext context) {
    return Scaffold(
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
            if (enrollmentProvider.enrollments.isEmpty) {
              return const Center(
                child: Text(
                  'any course has not been enrolled  yet ',
                  style: TextStyle(fontSize: 16),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            UpdateEnrollmentScreen(id: enrollment.id)));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEnrollementScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
