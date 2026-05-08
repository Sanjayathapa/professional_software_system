import 'package:ciheapp/model/enrollementmodel.dart';
import 'package:ciheapp/provider/api/group_member_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDetailsScreen extends StatefulWidget {
  final int groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  Group? group;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchgroupmember();
  });
  }

  Future<void> fetchgroupmember() async {
    try {
      final provider = Provider.of<GroupProvider>(context, listen: false);
      final fetchedGroup = await provider.fetchgroupmember(widget.groupId);
      setState(() {
        group = fetchedGroup;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : group == null
                  ? const Center(child: Text('No group data found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRow('Group Name:', group!.groupname),
                              const SizedBox(height: 10),
                              _buildRow('Course:', group!.courseName),
                              const SizedBox(height: 20),
                             
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromARGB(255, 250, 96, 7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16,color: Colors.black),
          ),
        ),
      ],
    );
  }
}
