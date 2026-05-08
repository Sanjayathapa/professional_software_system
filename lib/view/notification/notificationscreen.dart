

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:principles_ss/model/notificationmodel_api.dart';
import 'package:principles_ss/provider/api/announcementprovider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;


class StudentNotificationScreen extends StatefulWidget {
  const StudentNotificationScreen({super.key});

  @override
  State<StudentNotificationScreen> createState() => _StudentNotificationScreenState();
}

class _StudentNotificationScreenState extends State<StudentNotificationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = Provider.of<AnnouncementProvider>(context, listen: false);
      await provider.initNotifications();
      await provider.fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnouncementProvider>(context);
    final notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text("No notifications available."))
               : RefreshIndicator(
            onRefresh: () async {
              await provider.fetchNotifications();
            },
            child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading:  getNotificationIcon(),
                       title: Text(
                          notification.message.contains('\n')
                              ? notification.message.split('\n')[0]
                              : notification.message,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.message),
                            const SizedBox(height: 4),
                            
                            Text(
                            '${DateFormat('yyyy-MM-dd hh:mm a').format(notification.timestamp)} • ${timeago.format(notification.timestamp)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          ],
                        ),
                             isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                 _showDeleteConfirmationDialog(notification);},
                            ),
                      ),
                    );
                  },
                ),
    ));
  }
    Widget getNotificationIcon() {

    return CircleAvatar(
      backgroundColor: Colors.orange.withOpacity(0.2),
      child: Icon(
        Icons.campaign,
        color: Colors.orange,
      ),
    );
  }
   Future<void> _showDeleteConfirmationDialog(
      NotificationModel notifications) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Notification'),
          content:
              const Text('Are you sure you want to delete this notification?'),
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
                setState(() {
                  _deleteNotification(notifications.id.toString());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNotification(String id) async {
    final notificationprovider =
        Provider.of<AnnouncementProvider>(context, listen: false);
    try {
      await notificationprovider.deletestudentannouncement(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notification deleted successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to delete Notification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }
}


