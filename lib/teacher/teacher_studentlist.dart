import 'package:ciheapp/model/user.dart';
import 'package:ciheapp/provider/api/studentlist_provider.dart';
import 'package:ciheapp/view/message/chat_screen.dart';
import 'package:ciheapp/view/message/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherStudentList extends StatefulWidget {
  const TeacherStudentList({Key? key}) : super(key: key);

  @override
  State<TeacherStudentList> createState() => _TeacherStudentListState();
}

class _TeacherStudentListState extends State<TeacherStudentList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>Provider.of<StudentProvider>(context, listen: false).fetchStudentssList(context));
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final students = studentProvider.students;

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: studentProvider.search,
            ),
          ),
          Expanded(
            child:studentProvider.isLoading ? const Center(child: CircularProgressIndicator())
      : students.isEmpty
          ? const Center(child: Text('Student not found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(student.username
                                .substring(0, 1)
                                .toUpperCase()),
                          ),
                          title: Text(student.username),
                         
                          trailing: IconButton(
                            icon: const Icon(Icons.message),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    userId: student.id.toString(),
                                    userName: student.username,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
