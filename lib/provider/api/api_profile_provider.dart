import 'dart:convert';
import 'package:ciheapp/model/apiusers.dart';
import 'package:ciheapp/model/user.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilesProvider with ChangeNotifier {
  Users? _user;
  User? _notification;
  bool _isLoading = false;
  String? _error;
  String? get error => _error;

  User? get notification => _notification;
  Users? get user => _user;
  bool get isLoading => _isLoading;

  final String baseUrl = 'https://sydney.bgfootballacademy.com';
 

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/view-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _user = Users.fromJson(data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      debugPrint('Profile fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/update-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phoneNumber,
        }),
      );
     print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        await fetchUserProfile();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Profile update error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
