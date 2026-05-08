import 'package:ciheapp/admin/course/addcourse.dart';
import 'package:ciheapp/admin/group/addgroup.dart';
import 'package:ciheapp/admin/group/groupmember/groupmember.dart';
import 'package:ciheapp/provider/api/enrollementprovider.dart';
import 'package:ciheapp/provider/api/group_member_provider.dart';

import 'package:ciheapp/admin/group/editgroups.dart';
import 'package:ciheapp/admin/group/groupdetails.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<GroupProvider>(context, listen: false).fetchGroup();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Screen'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => GroupProvider()..fetchGroup(),
        child: Consumer<GroupProvider>(
          builder: (context, groupProvider, child) {
            if (groupProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (groupProvider.errorMessage != null) {
              return Center(
                child: Text(
                 'No groups have been added yet.',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (groupProvider.groups.isEmpty) {
              return const Center(
                child: Text(
                  'No groups have been added yet.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: groupProvider.groups.length,
                itemBuilder: (context, index) {
                  final group = groupProvider.groups[index];

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
                                group.groupname,
                                style: const TextStyle(
                                   color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                group.facultyName ?? 'Unknown Faculty',
                                style: const TextStyle(
                                   fontSize: 16,
                                  color: Color.fromARGB(255, 1, 101, 56),
                                ),
                              ),
                               const SizedBox(height: 8),
                              Text(
                               'Course: ${ group.courseName}',
                                style: const TextStyle(
                                   fontSize: 16,
                                  color: Color.fromARGB(255, 187, 4, 4),
                                ),
                              ),
                               const SizedBox(height: 8),
                              Text(
                              'TeacherName: ${ group.teacherName ?? 'Unknown Teacher'}' ,
                                style: const TextStyle(
                                   fontSize: 16,
                                  color: Color.fromARGB(255, 249, 139, 22),
                                ),
                              ),
                               const SizedBox(height: 8),
                              Text(
                              'Batch:${ group.batch ?? 'Unknown Batch'}',
                                style: const TextStyle(
                                   fontSize: 16,
                                  color: Color.fromARGB(255, 6, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                             const PopupMenuItem(
                              value: 'members',
                              child: Text('Group Members'),
                            ),
                            const PopupMenuItem(
                              value: 'details',
                              child: Text('Group Details'),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Update Members'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          onSelected: (value) {
                             if (value == 'members') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      GroupMmeberScreen(groupId: group.id),
                                ),
                              );
                            } if (value == 'details') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      GroupDetailsScreen(groupId: group.id),
                                ),
                              );
                            } else if (value == 'edit') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          UpdategroupScreen(id: group.id)));
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(group.id);
                            }
                          },
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
              builder: (context) => AddGroupScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteConfirmationDialog(int groupId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this group?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Provider.of<GroupProvider>(context, listen: false)
                  .deletegroup(groupId);
              await _refreshData(context);
            },
          ),
        ],
      ),
    );
  }
}
