import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider with ChangeNotifier {
  int _students = 0;
  int _teachers = 0;
  int _courses = 0;
  int _activeUsers = 0;

  int get students => _students;
  int get teachers => _teachers;
  int get courses => _courses;
  int get activeUsers => _activeUsers;

  static const String baseUrl = 'https://sydney.bgfootballacademy.com';

  Future<void> fetchDashboardData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null || token.isEmpty) {
      _showSnackBar(context, 'Token not found. Please log in again.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        _students = data['total_student'];
        _teachers = data['total_teacher'];
        _courses = data['total_course'];
        _activeUsers = data['total_active_user'];

        notifyListeners();
      } else {
        _showSnackBar(context, 'Failed to fetch dashboard data.');
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred while fetching dashboard data.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
      ),
    );
  }
}
