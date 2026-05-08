import 'package:ciheapp/admin/group/groupmember/addgroup_members.dart';
import 'package:ciheapp/provider/api/group_member_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMmeberScreen extends StatefulWidget {
  final int groupId;

  const GroupMmeberScreen({super.key, required this.groupId});

  @override
  State<GroupMmeberScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupMmeberScreen> {
  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<GroupProvider>(context, listen: false)
        .fetchgroupmember(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => GroupProvider()..fetchgroupmember(widget.groupId),
        child: Consumer<GroupProvider>(
          builder: (context, groupProvider, child) {
            if (groupProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (groupProvider.errorMessage != null) {
              return Center(
                child: Text(
                  'No groups member have been added yet.',
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
                              const Text(
                                'Members:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...group!.membersNames.map((members) {
                              final groupId = members.groupId ?? 0;  
                              final mid = members.mId ?? 0;
                                return Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: const Icon(Icons.person),
                                          title: Text(members.name),
                                          trailing: PopupMenuButton(
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'member',
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
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (_) => GroupDetailsScreen(
                                                //         groupId: group.id),
                                                //   ),
                                                // );
                                              }
                                              if (value == 'details') {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (_) => GroupDetailsScreen(
                                                //         groupId: group.id),
                                                //   ),
                                                // );
                                              } else if (value == 'edit') {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (_) =>
                                                //             UpdategroupScreen(id: group.id)));
                                              } else if (value == 'delete') {
                                                _showDeleteConfirmationDialog(
                                                    groupId, mid);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
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
              builder: (context) => AddGroupMembersScreen(groupId: widget.groupId),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteConfirmationDialog(int groupId, int id) {
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
                  .deletegroupmembers(groupId, id, context);
              await _refreshData(context);
            },
          ),
        ],
      ),
    );
  }
}
