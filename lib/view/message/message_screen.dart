import 'package:principles_ss/model/apiusers.dart';
import 'package:principles_ss/provider/api/messageprovider.dart';
import 'package:principles_ss/view/message/chat_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _isInitialized = false;
   String _searchQuery = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
       _loadContacts();
      });
      
      _isInitialized = true;
    }
  }

  Future<void> _loadContacts() async {
    final messageProvider = Provider.of<MessagesProvider>(context, listen: false);
    await messageProvider.fetchContacts();
    messageProvider.setupMessageListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                  context.read<MessagesProvider>().searchContacts(value.trim().toLowerCase());
              },
            ),
          ),
          
          
          Expanded(
            child: _buildContactsList(),
          ),
        ],
      ),
   
    );
  }

  Widget _buildContactsList() {
    return Consumer<MessagesProvider>(
      builder: (context, messageProvider, child) {
        if (messageProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final contacts = messageProvider.contacts.where((contact) {
        return contact.name.toLowerCase().contains(_searchQuery);
      }).toList();
        
        if (contacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No conversations yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: contacts.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 243, 159, 33),
                  backgroundImage: contact.profileImageUrl != null
                      ? NetworkImage(contact.profileImageUrl!)
                      : null,
                  child: contact.profileImageUrl == null
                      ? Text(contact.name.substring(0, 1).toUpperCase())
                      : null,
                ),
                title: Text(contact.name),
                subtitle: Text(_getRoleText(contact.role),style: TextStyle(color: Colors.lightGreen),),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(userId: contact.id.toString(), userName: contact.name),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  String _getRoleText(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case  UserRole.lecturer:
        return 'Teacher';
      case UserRole.admin:
        return 'Administrator';
      default:
        return 'User';
    }
  }
}

