import 'dart:convert';
import 'package:ciheapp/model/enrollementmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EnrollmentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Enrollment> _enrollments = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Enrollment> get enrollments => _enrollments;

final String baseUrl = 'https://sydney.bgfootballacademy.com';

  Future<void> fetchEnrollments() async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

     final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

     final Uri apiUrl = Uri.parse('$baseUrl/api/enrollments');
    final response = await http.get(
     apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
   print('Response status: ${response.statusCode}');
   print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      _enrollments = jsonResponse.map((data) => Enrollment.fromJson(data)).toList();
    } else {
      _errorMessage = 'Failed to load enrollments';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitEnrollment(int courseId) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/enrollments');
    final response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
       
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'course_id': courseId,
        
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
    
      fetchEnrollments();
    } else {
      _errorMessage = 'Failed to submit enrollment';
    }

    _isLoading = false;
    notifyListeners();
  }
  Future<void> updateEnrollment(int id, int courseId) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/enrollments/$id');
    final response = await http.put(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',      
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'course_id': courseId,
        
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
    
      fetchEnrollments();
    } else {
      _errorMessage = 'Failed to submit enrollment';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateEnrollmentStatus( BuildContext context, id, String newStatus) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

   final Uri apiUrl = Uri.parse('$baseUrl/api/enrollments/$id');
    notifyListeners();

    final response = await http.put(
     apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        },
      body: jsonEncode({
        "course_id": id,
        "status": newStatus
        }),
    );

   print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      await fetchEnrollments(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enrollment status updated successfully!'),
       backgroundColor: Colors.green, )
      );
    } else {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update enrollment status',style: TextStyle(color: const Color.fromARGB(255, 251, 250, 250)),), backgroundColor: const Color.fromARGB(255, 253, 4, 4),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update enrollment status',style: TextStyle(color: const Color.fromRGBO(246, 245, 245, 1)),), backgroundColor: const Color.fromARGB(255, 249, 10, 10),
        ),
      );
  } finally {
   
    notifyListeners();
  }
}

}


