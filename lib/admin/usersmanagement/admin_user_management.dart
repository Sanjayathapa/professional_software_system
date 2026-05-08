import 'package:ciheapp/admin/usersmanagement/addusers.dart';
import 'package:ciheapp/admin/usersmanagement/editusers.dart';
import 'package:ciheapp/admin/usersmanagement/usersdetails.dart';
import 'package:ciheapp/model/apiusers.dart';
import 'package:ciheapp/model/user.dart';
import 'package:ciheapp/service/api/usermanagement_service.dart';
import 'package:flutter/material.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({Key? key}) : super(key: key);

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FocusNode _searchFocusNode = FocusNode();
 final TextEditingController _searchController = TextEditingController();

  List<User> _students = [];
  List<User> _faculty = [];
  List<User> _filteredStudents = [];
  List<User> _filteredFaculty = [];
  String _searchQuery = "";

  @override
void initState() {
  super.initState();
  _tabController = TabController(length: 2, vsync: this);
  _searchFocusNode.addListener(_onFocusChanged);
  _searchController.addListener(_onSearchQueryChanged);
  _loadUsers(); 
}

void _loadUsers() async {
  try {
    final users = await UserManagementService().fetchUsers();
    final students = users
        .where((user) => user['role'] == UserRole.student)
        .map((user) => User.fromJson(user))
        .toList();
    final faculty = users
        .where((user) => user['role'] == UserRole.lecturer)
        .map((user) => User.fromJson(user))
        .toList();

    setState(() {
      _students = students;
      _faculty = faculty;
      _filteredStudents = students;
      _filteredFaculty = faculty;
    });
  } catch (e) {
    print('Error loading users: $e');
  }
}

void _filterUsers(String query) {
  setState(() {
    _searchQuery = query;
    _filteredStudents = _students.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _filteredFaculty = _faculty.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  });
}


  @override
  Widget build(BuildContext context) {
    final userManagementService = UserManagementService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
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
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 117, 171, 251),
                  borderRadius: BorderRadius.circular(8),
                ),
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Students'),
                  Tab(text: 'Teachers'),
                ],
              ),
            ),
          ),  
              Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: _filterUsers,
      ),
    ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: userManagementService.fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found'));
              }
              final users = snapshot.data!
                  .map((userMap) => User.fromJson(userMap))
                  .toList();
              final students =
                  users.where((user) => user.role == UserRole.student).toList();
              final faculty = users
                  .where((user) => user.role == UserRole.lecturer)
                  .toList();

              return Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUserList(students, UserRole.student),
                    _buildUserList(faculty, UserRole.lecturer),
                  ],
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddUsersScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserList(List<User> users, UserRole role) {
    return Column(
      children: [
     
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(user.name.isNotEmpty
                            ? user.name.substring(0, 1).toUpperCase()
                            : '')
                        : null,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Text('Users Details'),
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
                                                    UsersDetailsScreen(
                                                        id: user.id)));
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(user);
                      }
                    },
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(User user) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.name}?'),
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
                _deleteItem(user.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

 

  void _deleteItem(int id) async {
    try {
      await UserManagementService().deleteUsers(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Users deleted successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to delete users',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

   void _onSearchQueryChanged() {
    _filterUsers(_searchController.text);
  }

   void _onFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      
      if (_searchQuery.isNotEmpty) {
        _filterUsers('');
      }
    }
  }
}
