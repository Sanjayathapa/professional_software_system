import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Student {
  final int id;
  final String username;

  Student({required this.id, required this.username});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      username: json['username'],
    );
  }
}

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
    bool _isLoading = false;
    
  List<Student> get students => _filteredStudents;

  static const String baseUrl = 'https://sydney.bgfootballacademy.com';
  bool get isLoading => _isLoading;
Future<void> fetchStudentssList(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null || token.isEmpty) {
      _showSnackBar(context, 'Token not found. Please log in again.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/getstudents'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['data'] != null && decoded['data']['students'] is List) {
          final studentsList = decoded['data']['students'] as List;

          _students = studentsList
              .where((user) => user['role'] == 'student')
              .map<Student>((user) => Student.fromJson(user))
              .toList();

          _filteredStudents = [..._students];
          notifyListeners();
        } else {
          _showSnackBar(context, 'Invalid response format.');
        }
      } else if (response.statusCode == 403) {
        _showSnackBar(context, 'Unauthorized access. Please check your role.');
      } else {
        _showSnackBar(context, 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception occurred: $e");
      _showSnackBar(context, 'Error occurred while fetching data.');
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredStudents = [..._students];
    } else {
      _filteredStudents = _students
          .where((student) =>
              student.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
