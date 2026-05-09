
import 'package:flutter/material.dart';
import 'package:principles_ss/provider/api/courseprovider.dart';
import 'package:provider/provider.dart';


class TeacherCourseList extends StatefulWidget {
  const TeacherCourseList({Key? key}) : super(key: key);

  @override
  State<TeacherCourseList> createState() => _TeacherCourseListState();
}

class _TeacherCourseListState extends State<TeacherCourseList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourses();
    });
  }

  Future<void> _loadCourses() async {
    final courseProvider = Provider.of<CoursesProvider>(context, listen: false);
    await courseProvider.fetchTeacherCourses();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CoursesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: courseProvider.isLoading
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
                            style: Theme.of(context).textTheme.titleMedium,
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
                            title: Text(course.name,style: TextStyle(color:Colors.blue),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description:${course.description ?? 'No description available'}'),
                                const SizedBox(height: 4),
                               Text('Start Date: ${course.startDate}',style: TextStyle(color:Colors.green),),
                                      const SizedBox(height: 4),
                                      Text(
                                        'End Date: ${course.endDate}'
                                       ,style: TextStyle(color:Colors.red),
                                      ),
                              ],
                            ),
                            // isThreeLine: true,
                            // trailing:
                            //     const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                             
                            },
                          ),
                        );
                      },
                    ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
       
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
