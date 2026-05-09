
import 'package:flutter/material.dart';
import 'package:principles_ss/admin/course/admincourse_management.dart';
import 'package:principles_ss/admin/group/groupscreen.dart';
import 'package:principles_ss/provider/api/dashboardapiu_provider.dart';
import 'package:principles_ss/service/api/loginservice.dart';
import 'package:principles_ss/view/authscreen/loginscreen.dart';
import 'package:principles_ss/view/message/apimessage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'usersmanagement/admin_user_management.dart';
import 'admin_notification_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

   String? _username;

  @override
  void initState() {
    super.initState();
     Future.microtask(() {
    Provider.of<DashboardProvider>(context, listen: false).fetchDashboardData(context);
  });
    _loadUsername();
  }

 Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');

    setState(() {
      _username = storedUsername ?? 'User';
    });
  }
  @override
  Widget build(BuildContext context) {
    final double screenwidth = MediaQuery.of(context).size.width;
    final double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AdminNotificationManagement()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              UserService userService = UserService();
              final bool success = await userService.logout();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Successfully logged out.'
                        : 'Logout failed. Please try again.',
                    style: TextStyle(fontSize: screenwidth * 0.035),
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );

              if (success) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${_username ?? 'Admin'}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Administrator',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Consumer<DashboardProvider>(
          builder: (context, dashboard, _) {
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(context, 'Students', dashboard.students, Icons.school, Colors.blue),
                _buildStatCard(context, 'Teacher', dashboard.teachers, Icons.people, Colors.green),
                _buildStatCard(context, 'Courses', dashboard.courses, Icons.book, Colors.orange),
                _buildStatCard(context, 'Active Users', dashboard.activeUsers, Icons.person, Colors.purple),
              ],
            );
          },
        ),

            const SizedBox(height: 24),
            Text(
              'Management',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildManagementCard(
              context,
              'User Management',
              'Add, edit, or remove users',
              Icons.manage_accounts,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminUserManagement(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildManagementCard(
              context,
              'Course Management',
              'Manage courses and enrollments',
              Icons.book,
              Colors.green,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminCourseManagement(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
             _buildManagementCard(
              context,
              'Message',
              'Send messages to users',
              Icons.message,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApiMessagesScreen (),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // _buildManagementCard(
            //   context,
            //   'Enrollment Management',
            //   'Manage course enrollments',
            //   Icons.assignment_turned_in,
            //   Colors.red,
            //   () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => EnrollmentScreen(),
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(height: 16),
            _buildManagementCard(
              context,
              'Group',
              'Add, edit, or remove groups',
              Icons.settings,
              Colors.purple,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildManagementCard(
              context,
              'Notification Management',
              'Send announcements and notifications',
              Icons.notifications,
              Colors.orange,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminNotificationManagement(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    int value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                radius: 24,
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
