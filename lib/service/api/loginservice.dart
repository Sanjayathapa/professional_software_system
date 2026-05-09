import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:principles_ss/admin/admin_dashboard.dart';
import 'package:principles_ss/teacher/teacher_dashboard.dart';
import 'package:principles_ss/view/student/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserService {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  final String baseUrl = 'https://sydney.bgfootballacademy.com';

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 246, 243, 243),
          content: SizedBox(
            height: 100.0,
            width: 90.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(
                  'logging..',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 6, 6, 6),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final Uri apiUrl = Uri.parse('$baseUrl/api/login');

      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (responseData.containsKey('message') &&
          responseData['message'].contains('Access denied')) {
        print('Access denied due to bot protection');
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Access denied. Bot protection triggered.')),
        );
        return false;
      }

      if (response.statusCode == 200) {
        final String token = responseData['token'];
        final String? role = responseData['user']['role'];

        print('Token received: $token');
        await storeApiToken(token);
        await storeusername(responseData['user']['username']);
 
        switch (role) {
           case 'admin':
           Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AdminDashboard()),
            );
            break;
          case 'lecturer':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TeacherDashboard()),
            );
            break;
          case 'student':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
            break;

          default:
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unknown role.')),
            );
            return false;
        }

        return true;
      } else {
        Navigator.pop(context);
        print('Login failed. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to login',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 252, 28, 28),
          ),
        );
        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred during login.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 252, 28, 28),
        ),
      );

      return false;
    }
  }

  Future<void> storeApiToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final isStored = await prefs.setString('api_token', token);
    if (isStored) {
      print('Token stored successfully: $token');
    } else {
      print('Failed to store token');
    }
  }

  Future<void> storeusername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final isStored = await prefs.setString('username', username);
    if (isStored) {
      print('username stored successfully: $username');
    } else {
      print('Failed to store username');
    }
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final token = prefs.getString('api_token');
      if (token == null) {
        print('No API token found.');
        return false;
      }
      print('Removing API token: $token');
      await prefs.remove('$baseUrl/api/logout');

      print('API token removed successfully');

      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    final prefs = await SharedPreferences.getInstance();
    if (newPassword != confirmPassword) {
      print('New password and confirm password do not match!');
      return false;
    }
    final url = Uri.parse('$baseUrl/api/change-password');

    try {
      final token = prefs.getString('api_token');
      if (token == null) {
        print('No API token found.');
        return false;
      }
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'old_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        print('Password changed successfully.');
        return true;
      } else {
        final errorData = json.decode(response.body);
        print('Error: ${errorData['message'] ?? 'Unknown error'}');
        return false;
      }
    } catch (error) {
      print('An error occurred: $error');
      return false;
    }
  }
}
