import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:principles_ss/model/notificationmodel_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementProvider with ChangeNotifier {
  
   final String baseUrl = 'https://sydney.bgfootballacademy.com';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  List<NotificationsModel> _notificationss = [];
  List<NotificationsModel> get notificationss => _notificationss;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showLocalNotification(NotificationModel notification) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'new_notification_channel',
      'New Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.message,
      platformDetails,
    );
  }
  Future<bool> sendAnnouncement({
    required List<int> userIds,
    required String message,
    required String course,  
     required String title,
    required String scheduledAt,
  }) async {
    final body = {
      "user_ids": userIds,
       "title": title,
       "course": course,
      "message": message,
      "scheduled_at": scheduledAt,
    };
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/notifications'), 
        headers: {  
           'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          },

        body: jsonEncode(body),
      );
      print("API Response: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      print("body: $body");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("Failed to send announcement: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error sending announcement: $e");
      return false;
    }
  }
   Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    print("API Response: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        final List<NotificationModel> fetched = data
            .map((item) => NotificationModel.fromJson(item))
            .toList();

        _notifications = fetched;

      
        final lastJson = prefs.getString('last_notification');
        final lastNotification = lastJson != null
            ? NotificationModel.fromMap(jsonDecode(lastJson))
            : null;

      
        if (_notifications.isNotEmpty) {
          final latest = _notifications.first;
          if (lastNotification == null ||
              latest.timestamp.isAfter(lastNotification.timestamp)) {
            await showLocalNotification(latest);
            prefs.setString('last_notification', jsonEncode(latest.toMap()));
          }
        }
      } else {
        debugPrint("Fetch failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchScheduledNotifications() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/get-schedule-notification'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    print("API Response: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        final List<NotificationsModel> fetched = data
            .map((item) => NotificationsModel.fromJson(item))
            .toList();

        _notificationss = fetched;

      
        final lastJson = prefs.getString('last_notification');
        final lastNotification = lastJson != null
            ? NotificationsModel.fromMap(jsonDecode(lastJson))
            : null;

      
        if (_notifications.isNotEmpty) {
          final latest = _notifications.first;
          if (lastNotification == null ||
              latest.timestamp.isAfter(lastNotification.timestamp)) {
            await showLocalNotification(latest);
            prefs.setString('last_notification', jsonEncode(latest.toMap()));
          }
        }
      } else {
        debugPrint("Fetch failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
    Future<void> deleteannouncement(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/delete-schedule-notification/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
print("API Response: ${response.statusCode}");
      print("API Response Body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('announcement deleted successfully.');
    } else {
      throw Exception('Failed to delete announcement');
    }
  }
   Future<void> deletestudentannouncement(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/notifications/$id/delete'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
print("API Response: ${response.statusCode}");
      print("API Response Body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('announcement deleted successfully.');
    } else {
      throw Exception('Failed to delete announcement');
    }
  }
}
