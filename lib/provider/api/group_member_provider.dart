import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:principles_ss/model/enrollementmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Group> _groups = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Group> get groups => _groups;

  final String baseUrl = 'https://sydney.bgfootballacademy.com';

  Future<void> fetchGroup() async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      _errorMessage = 'No token found';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/admin/groups');
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
      _groups = jsonResponse.map((data) => Group.fromJson(data)).toList();
    } else {
      _errorMessage = 'Failed to load groups';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitgroup(int courseId, String groupname) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/admin/groups');
    final response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'course_id': courseId, "group_name": groupname}),
    );
 print('course id ${courseId}');
    print('group name ${groupname}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      fetchGroup();
    } else {
      _errorMessage = 'Failed to submit enrollment';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updategroup(int id, int courseId, String groupname) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/admin/groups/$id');
    final response = await http.put(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'course_id': courseId, 'group_name': groupname}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      fetchGroup();
    } else {
      _errorMessage = 'Failed to submit enrollment';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Group> fetchgroupDetails(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/groups/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Group.fromJson(data);
    } else {
      throw Exception('Failed to load group: ${response.statusCode}');
    }
  }

  Future<void> deletegroup(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/groups/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('group deleted successfully.');
    } else {
      throw Exception('Failed to delete group');
    }
  }

  /////groupmember
  ///
  Future fetchgroupmember(int groupId) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      _errorMessage = 'No token found';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/admin/groups/$groupId/members');
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
      final jsonResponse = json.decode(response.body);

      final group = Group.fromJson(jsonResponse);

      _groups = [group];
    } else {
      _errorMessage = 'Failed to load group members';
    }

    _isLoading = false;
    notifyListeners();
  }

 Future<void> submitgropmembers(int courseId, int studentid,int groupId) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final Uri apiUrl = Uri.parse('$baseUrl/api/admin/groups/$groupId/members');
    final response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
       
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'course_id': courseId,
        'user_id': studentid
      }),
    );
print('group id ${groupId}');
    print('course id ${courseId}');
    print('user id ${studentid}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
    
     fetchgroupmember(courseId);
    } else {
      _errorMessage = 'Failed to submit enrollment';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deletegroupmembers(
    int groupId,
    int id,
    BuildContext context
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/groups/$groupId/members/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    print(' user id ${id}');
     print(' group id ${groupId}');

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('group members deleted successfully.');
       ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group members Deleted Sucessfully',style: TextStyle(color:Colors.white),),backgroundColor: Colors.green,),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to delete',style: TextStyle(color:Colors.white),),backgroundColor: Color.fromARGB(255, 252, 6, 6),),
    );
    }
  }
}
