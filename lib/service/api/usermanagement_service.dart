import 'dart:convert';
import 'package:ciheapp/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserManagementService {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  final String baseUrl = 'https://sydney.bgfootballacademy.com';

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    if (token == null) {
      _errorMessage = 'No API token found.';
      print(_errorMessage);
      return [];
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/admin/users');

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        // Convert List<dynamic> to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> users =
            data.map((user) => Map<String, dynamic>.from(user)).toList();
        return users;
      } else {
        _errorMessage = 'Failed to load users. Status code: ${response.statusCode}';
        print(_errorMessage);
        return [];
      }
    } catch (e) {
      _errorMessage = 'Error fetching users: $e';
      print(_errorMessage);
      return [];
    }
  }
  Future<User> fetchUserDetails(int id) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('api_token');

  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/api/admin/users/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return User.fromJson(data); 
  } else {
    throw Exception('Failed to load course: ${response.statusCode}');
  }
}

     Future<void> deleteUsers(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('users deleted successfully.');
    } else {
      throw Exception('Failed to delete users');
    }
  }


  Future<void> editUsers(int id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/users/$id'),
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
        print('Item edited successfully.');
      } else {
        throw Exception('Failed to edit users: ${response.body}');
      }
    } catch (e) {
      print("Error updating users: $e");
      throw Exception('Error updating users: $e');
    }
  }


  Future<void> addUsers(Map<String, dynamic> categoryData) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/admin/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(categoryData),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('users added successfully.');
      } else {
        throw Exception('Failed to add users: ${response.body}');
      }
    } catch (e) {
      print("Error adding users: $e");
      throw Exception('Error adding users: $e');
    }
  }
}
