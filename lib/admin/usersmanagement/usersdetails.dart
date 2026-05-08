import 'package:ciheapp/admin/course/editcourse.dart';
import 'package:ciheapp/admin/usersmanagement/editusers.dart';
import 'package:ciheapp/model/coursemodel.dart';
import 'package:ciheapp/model/user.dart';

import 'package:ciheapp/service/api/usermanagement_service.dart';
import 'package:flutter/material.dart';

class UsersDetailsScreen extends StatefulWidget {
  final int id;

  const UsersDetailsScreen({super.key, required this.id});

  @override
  State<UsersDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<UsersDetailsScreen> {
  late Future<User> _UserFuture;
  final UserManagementService _userService = UserManagementService();

  @override
  void initState() {
    super.initState();
    _UserFuture = _userService.fetchUserDetails(widget.id);
   
  }

   Future<void> _refresh() async {
    setState(() {
      _UserFuture = _userService.fetchUserDetails(widget.id); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Details'),
      ),
      body:RefreshIndicator( onRefresh: _refresh, 
      child: FutureBuilder<User>(
        future: _UserFuture,
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
            final user = snapshot.data!;
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
                    _buildDetailRow(Icons.person, "UserName", user.name),
                    _buildDetailRow(Icons.email, "Email", user.email),
                    _buildDetailRow(
                        Icons.person_4_outlined, "First Name", user.firstname),
                    _buildDetailRow(Icons.person_3, "Last Name", user.lastname),
                    _buildDetailRow(Icons.group, "Role",
                        user.role.toString().split('.').last),
                    _buildDetailRow(Icons.check_circle, "Status", user.status),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No course data found'));
          }
        },
      ),),
      floatingActionButton: FutureBuilder<User>(
        future: _UserFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final course = snapshot.data!;
            return FloatingActionButton.extended(
              onPressed: () {
                _editUsers({
                  'id': course.id,
                  'username': course.name,
                  'role': course.role.toString().split('.').last,
                  'status': course.status,
                  'first_name': course.firstname,
                  'last_name': course.lastname,
                  'email': course.email,
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

  Widget _buildDetailRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 1, 110, 26),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 8, 8, 8),
            ),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 31, 2, 197)),
          ),
        ],
      ),
    );
  }

  Widget _buildsDetailRow(String title, String? value) {
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
              color: Color.fromARGB(255, 8, 8, 8),
            ),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 31, 2, 197)),
          ),
        ],
      ),
    );
  }

  void _editUsers(Map<String, dynamic> users) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditusersScreen(
          id: users['id'] != null ? users['id'] as int : 0,
          username: users['username'] ?? '',
          role: users['role'] ?? '',
          status: users['status'] ?? '',
          firstname: users['first_name'] ?? '',
          lastname: users['last_name'] ?? '',
          email: users['email'] ?? '',
        ),
      ),
    );
  }
}
