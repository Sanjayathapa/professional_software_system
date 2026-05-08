import 'package:ciheapp/model/apiusers.dart';
import 'package:ciheapp/model/message.dart';
import 'package:ciheapp/service/api/messageservice.dart';
import 'package:flutter/material.dart';


class MessagesProvider with ChangeNotifier {
  final TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;
  List<Users> _contacts = [];
  bool _isLoading = false;
  String? _error;

  List<Message> _messages = [];
  int? _currentChatUserId;

  // List<Users> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Message> get messages => _messages;
    String _searchQuery = '';
  List<Users> _filteredContacts = [];

  List<Users> get contacts => _searchQuery.isEmpty ? _contacts : _filteredContacts;
  final MessageService _messageService = MessageService();

Future<void> setCurrentChatUserId(String userId) async {
  _currentChatUserId = int.tryParse(userId); 
  await fetchMessages(userId);
}

 

void addLocalMessage(Message message) {
  _messages.add(message);
  notifyListeners();
}

  void searchContacts(String query) {
    _searchQuery = query;
    _filteredContacts = _contacts
        .where((contact) => contact.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
  Future<void> fetchContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final contacts = await _messageService.getContacts();
    _contacts = [...contacts];
     _filteredContacts = [...contacts];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  Future<void> fetchMessages(String userId) async {
    try {
      _messages = await MessageService().getMessages(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

Future<bool> sendMessage(String receiverId, String content) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final success = await _messageService.sendMessage([int.parse(receiverId)], content);

    if (success) {
      await fetchMessages(receiverId); 
    }

    _isLoading = false;
    notifyListeners();
    return success;
  } catch (e) {
    _isLoading = false;
    _error = e.toString();
    notifyListeners();
    return false;
  }
}

Future<void> deleteMessage(int messageId) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final success = await _messageService.deleteMessage(messageId);

    if (success) {
     
      _messages.removeWhere((message) => message.id == messageId);
    }

    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _isLoading = false;
    _error = e.toString();
    notifyListeners();
  }
}


  void setupMessageListeners() {
    _messageService.onNewMessage((Message message) {
      if (message.senderId == _currentChatUserId || message.receiverId == _currentChatUserId) {
        _messages = [..._messages, message];
        notifyListeners();
      }
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}