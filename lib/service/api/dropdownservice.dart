import 'dart:convert';
import 'package:ciheapp/model/apiusers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DropdownService {
  static const String baseUrl = 'https://cihe.gloryspanepal.com';

  
  static Future<List<Map<String, dynamic>>> fetchCourseList() async {
    
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');
    
    if (token == null || token.isEmpty) {
      print("No valid token found!");
      throw Exception('No token found');
    }

    print(" Token retrieved: $token");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/enrollments/courses-list'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(" API Response Received: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(" Decoded Response: $data");

        
        if (data is List) {
          print("List Found: $data");
          return List<Map<String, dynamic>>.from(data);
        } else {
          print(" Error: Response is not a list");
          throw Exception('Invalid response format: Expected a list');
        }
      } else {
        print(" API call failed with status ${response.statusCode}");
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print(" Exception occurred: $e");
      throw Exception("Fetch failed: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCourse() async {
    
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');
    
    if (token == null || token.isEmpty) {
      print("No valid token found!");
      throw Exception('No token found');
    }

    print(" Token retrieved: $token");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/course-for-notification '), 
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(" API Response Received: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(" Decoded Response: $data");

        
        if (data is List) {
          print("List Found: $data");
          return List<Map<String, dynamic>>.from(data);
        } else {
          print(" Error: Response is not a list");
          throw Exception('Invalid response format: Expected a list');
        }
      } else {
        print(" API call failed with status ${response.statusCode}");
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print(" Exception occurred: $e");
      throw Exception("Fetch failed: $e");
    }
  }
   static Future<List<Map<String, dynamic>>> fetchStudentList() async {
    print(" Calling fetchstudentList()...");
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');
    
    if (token == null || token.isEmpty) {
      print("No valid token found!");
      throw Exception('No token found');
    }

    print(" Token retrieved: $token");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/users'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(" API Response Received: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(" Decoded Response: $data");

        
        if (data is List) {
            final students = data
            .where((user) => user['role'] == 'student'|| user['role'] == 'lecturer')
            .map<Map<String, dynamic>>((student) => {
                  'id': student['id'],
                  'username': student['username'],
                })
            .toList();

        print("🎓 Filtered Students: $students");
        return students;
        } else {
          print(" Error: Response is not a list");
          throw Exception('Invalid response format: Expected a list');
        }
      } else {
        print(" API call failed with status ${response.statusCode}");
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print(" Exception occurred: $e");
      throw Exception("Fetch failed: $e");
    }
  }
   Future<List<Users>> getstudents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/notifications-students'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (!data.containsKey('students')) {
        throw Exception('Invalid format: "students" key not found');
      }

      final List<dynamic> studentList = data['students'];
      return studentList.map((json) => Users.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students: ${response.statusCode}');
    }
  }
}