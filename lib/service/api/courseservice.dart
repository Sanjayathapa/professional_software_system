import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:principles_ss/model/coursemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CoursesService {
  final String baseUrl = 'https://sydney.bgfootballacademy.com';
  

  Future<List<Courses>> getCourses() async {
   
   final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

     final Uri apiUrl = Uri.parse('$baseUrl/api/admin/courses');

    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json', 
      },
    );
   print('Response status: ${response.statusCode}');
   print('Response body: ${response.body}');

   if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Courses.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

Future<List<Courses>> getTeacherCourses() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('api_token');

  if (token == null) {
    throw Exception('No token found');
  }

  final Uri apiUrl = Uri.parse('$baseUrl/api/lecturer/courses');

  final response = await http.get(
    apiUrl,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    final json = jsonDecode(response.body);
    final List<dynamic> data = json['data']; 
    return data.map((json) => Courses.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load courses: ${response.statusCode}');
  }
}


   Future<void> deleteCourse(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/courses/$id'),
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

Future<Courses> fetchCourseDetails(int id) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('api_token');

  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/api/admin/courses/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return Courses.fromJson(data); 
  } else {
    throw Exception('Failed to load course: ${response.statusCode}');
  }
}

  Future<void> editcourse(int id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/courses/$id'),
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


  Future<void> addcourse(Map<String, dynamic> CourseData) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/admin/courses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(CourseData),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Category added successfully.');
      } else {
        throw Exception('Failed to add users: ${response.body}');
      }
    } catch (e) {
      print("Error adding category: $e");
      throw Exception('Error adding category: $e');
    }
  }
}
