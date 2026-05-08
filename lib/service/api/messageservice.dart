import 'dart:convert';
import 'package:ciheapp/model/apiusers.dart';
import 'package:ciheapp/model/message.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


typedef MessageCallback = void Function(Message message);
class MessageService {
 MessageCallback? _onNewMessageCallback;

  void onNewMessage(MessageCallback callback) {
    _onNewMessageCallback = callback;
  }


  void simulateIncomingMessage(Message message) {
    _onNewMessageCallback?.call(message);
  }
  final String baseUrl = 'https://sydney.bgfootballacademy.com';

  Future<List<Users>> getContacts() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('api_token');

  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/api/get-people'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<Users> users = [];

   
  

    if (data.containsKey('admin')) {
      final adminData = data['admin'];
      if (adminData is Map<String, dynamic>) {
        users.add(Users.fromJson({...adminData, 'role': 'admin'}));
      }
    }

if (data.containsKey('students')) {
  final studentData = data['students'];
  if (studentData is List) {
    users.addAll(
      studentData.map((userJson) => Users.fromJson({...userJson, 'role': 'student'})).toList(),
    );
  }
}

if (data.containsKey('lecturers')) {
  final lecturerData = data['lecturers'];
  if (lecturerData is List) {
    users.addAll(
      lecturerData.map((userJson) => Users.fromJson({...userJson, 'role': 'lecturer'})).toList(),
    );
  }
}
    return users;
  } else {
    throw Exception('Failed to load contacts: ${response.statusCode}');
  }
}

 Future<List<Message>> getMessages(String receiverId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/api/get-messages/$receiverId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final conversation = data['conversation'] as List<dynamic>;
      return conversation.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages: ${response.statusCode}');
    }
  }

  Future<bool> sendMessage(List<int> receiverIds, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/send-messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'receiver_ids': receiverIds,
        'content': content,
      }),
    );
print( 'Response status of sending messages : ${response.statusCode}');
print('Response body: ${response.body}');
    return response.statusCode == 200;
  }
  Future<bool> deleteMessage(int messageId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('api_token');

  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.delete(
    Uri.parse('$baseUrl/api/delete-message/$messageId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print('Response status of deleting message: ${response.statusCode}');
  print('Response body: ${response.body}');

  return response.statusCode == 200;
}

}
