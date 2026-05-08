import 'package:ciheapp/admin/course/addcourse.dart';
import 'package:ciheapp/admin/course/detailscourse.dart';
import 'package:ciheapp/model/coursemodel.dart';
import 'package:ciheapp/provider/api/courseprovider.dart';
import 'package:ciheapp/provider/courses_provider.dart';
import 'package:ciheapp/service/api/courseservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCourseManagement extends StatefulWidget {
  const AdminCourseManagement({Key? key}) : super(key: key);

  @override
  State<AdminCourseManagement> createState() => _AdminCourseManagementState();
}

class _AdminCourseManagementState extends State<AdminCourseManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourses();
    });
  }

  Future<void> _loadCourses() async {
    await Provider.of<CoursesProvider>(context, listen: false).fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CoursesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                courseProvider.searchCourses(value);
              },
            ),
          ),
          Expanded(child:
              Consumer<CoursesProvider>(builder: (context, courseProvider, _) {
            return courseProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadCourses,
                    child: courseProvider.courses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.school,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No courses found',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: courseProvider.courses.length,
                            itemBuilder: (context, index) {
                              final course = courseProvider.courses[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 0),
                                child: ListTile(
                                  title: Text(course.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Start Date: ${course.startDate}'),
                                      const SizedBox(height: 4),
                                      Text(
                                        'End Date: ${course.endDate}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'details',
                                        child: Text('Details Course'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'enroll',
                                        child: Text('Manage Enrollment'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'details') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CourseDetailsScreen(
                                                        id: course.id)));
                                      } else if (value == 'enroll') {
                                      } else if (value == 'delete') {
                                        _showDeleteConfirmationDialog(course);
                                      }
                                    },
                                  ),
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                  );
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddCourseScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(Courses course) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Course'),
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
                _deleteCourse(course.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCourse(int id) async {
    try {
      await CoursesService().deleteCourse(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Course deleted successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to delete Course',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }
}
