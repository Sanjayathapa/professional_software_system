import 'package:ciheapp/admin/adminnotification.dart';
import 'package:ciheapp/model/notification_type.dart';
import 'package:ciheapp/model/notificationmodel_api.dart';
import 'package:ciheapp/provider/api/announcementprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNotificationManagement extends StatefulWidget {
  const AdminNotificationManagement({Key? key}) : super(key: key);

  @override
  State<AdminNotificationManagement> createState() =>
      _AdminNotificationManagementState();
}

class _AdminNotificationManagementState
    extends State<AdminNotificationManagement> {
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider =
          Provider.of<AnnouncementProvider>(context, listen: false);
      await provider.initNotifications();
      await provider.fetchScheduledNotifications();
    });
  }
  Future<void> _loadNotifications() async {
    final provider = Provider.of<AnnouncementProvider>(context, listen: false);
    await provider.fetchScheduledNotifications();
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnouncementProvider>(context);
    final notifications = provider.notificationss;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Management'),
      ),
      body: RefreshIndicator(
         onRefresh: _loadNotifications,
        child: Column(
          children: [
            Expanded(
              child: provider.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_off,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications available',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 0),
                          child: ListTile(
                            leading: getNotificationIcon(),
                            title: Text(notification.title ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.message,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sent: ${_formatDate(notification.timestamp)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () { _showDeleteConfirmationDialog(notification);},
                            ),
                            
                             
                         
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AdminNotificationScreen()));
        },
        icon: const Icon(Icons.send),
        label: const Text('Send Notification'),
      ),
    );
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _showDeleteConfirmationDialog(
      NotificationsModel notifications) async {
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
      await notificationprovider.deleteannouncement(id);
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
