
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:principles_ss/model/assignment.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AssignmentsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Assignments> _assignments = [];
  List<Assignments> get assignments => _assignments;

 final String baseUrl = 'https://sydney.bgfootballacademy.com';



  Future<void> fetchAssignments() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');
    
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/lecturer/assignments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          final List<dynamic> assignmentData = data['data'];
          _assignments = assignmentData.map((json) => Assignments.fromJson(json)).toList();
        } else {
          _assignments = [];
        }
      } else {
        throw Exception('Failed to load assignments');
      }
    } catch (e) {
      print('Error fetching assignments: $e');
      _assignments = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAssignment({
    required int courseId,
    required String title,
    required String description,
    required String link,
    required DateTime dueDate,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    final body = {
      "course_id": courseId,
      "title": title,
      "description": description,
      "due_date": dueDate.toIso8601String().substring(0, 10),
      "links": link,
    };
    print('course id ${courseId}');
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/lecturer/assignments"),
        headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json', 
        'Content-Type': 'application/json',
      
      },
        body: jsonEncode(body),
      );

      print('Request body: $body');
     print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Assignment uploaded successfully!",style: TextStyle(color:Colors.white),),backgroundColor: Color.fromARGB(255, 2, 189, 36),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("The due date field must be a date after today.",style: TextStyle(color:Colors.white),),backgroundColor: Colors.red,),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAssignment(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/lecturer/assignments/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Item deleted successfully.');
    } else {
      throw Exception('Failed to delete item');
    }
  }



  Future<void> editAssignment(int id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/lecturer/assignments/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('users edited successfully.');
      } else {
        throw Exception('Failed to edit users: ${response.body}');
      }
    } catch (e) {
      print("Error updating course: $e");
      throw Exception('Error updating course: $e');
    }
  }

 
   Future<void> fetchStudentAssignments() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');
    
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/student/submissions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
      if (data['success'] == true) {
  final List<dynamic> assignmentData = data['assignments'];
  _assignments = assignmentData.map((json) => Assignments.fromJson(json)).toList();
} else {
  _assignments = [];
}
      } else {
        throw Exception('Failed to load assignments');
      }
    } catch (e) {
      print('Error fetching assignments: $e');
      _assignments = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
