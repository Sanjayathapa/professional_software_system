import 'package:ciheapp/admin/course/editcourse.dart';
import 'package:ciheapp/model/coursemodel.dart';
import 'package:ciheapp/service/api/courseservice.dart';
import 'package:flutter/material.dart';


class CourseDetailsScreen extends StatefulWidget {
  final int id;

  const CourseDetailsScreen({super.key, required this.id});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late Future<Courses> _courseFuture;
  final CoursesService _coursesService = CoursesService(); 

  @override
  void initState() {
    super.initState();
    _courseFuture = _coursesService.fetchCourseDetails(widget.id); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
    
      ),
      body: FutureBuilder<Courses>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final course = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: Colors.deepPurple.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     _buildDetailRow("Faculty Name", course.faculty),
                    
                    _buildDetailRow("Course Name", course.name),
                    _buildDetailRow("Teacher Name", course.teacher),
                    _buildDetailRow("Batch", course.batch),
                    _buildDetailRow("Description", course.description),
                    _buildDetailRow("Start Date", course.startDate),
                    _buildDetailRow("End Date", course.endDate),
                    _buildDetailRow("Schedule", course.schedule),
                   
                    const SizedBox(height: 12),
                   
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No course data found'));
          }
        },
      ),
      floatingActionButton: FutureBuilder<Courses>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final course = snapshot.data!;
            return FloatingActionButton.extended(
              onPressed: () {
                _editCourse({
                  'id': course.id,
                  'name': course.name,
                  'faculty_name': course.faculty,
                  'teacher_name': course.teacher,
                  'batch': course.batch,
                  'description': course.description,
                  'start_date': course.startDate,
                  'end_date': course.endDate,
                  'schedule': course.schedule,
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
    
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 1, 122, 50),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
   void _editCourse(Map<String, dynamic> course) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditCourseScreen(
        id: course['id'] != null ? course['id'] as int : 0,
        faculty: course['faculty_name'] ?? '',
        teacher: course['teacher_name'] ?? '',
        batch: course['batch'] ?? '',
        schedule: course['schedule'] ?? '',  
        name: course['name'] ?? '', 
        description: course['description'] ?? '', 
        startdate: course['start_date'] ?? '',  
        enddate: course['end_date'] ?? '',  
      ),
    ),
  );
   
}
}
