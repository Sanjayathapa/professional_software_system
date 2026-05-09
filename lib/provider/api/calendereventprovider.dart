
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:principles_ss/model/calender_event.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class CalendarProvider extends ChangeNotifier {
  Map<DateTime, List<CalendarEvent>> _events = {};
  List<CalendarEvent> _selectedDayEvents = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<CalendarEvent> get selectedDayEvents => _selectedDayEvents;
  Map<DateTime, List<CalendarEvent>> get events => _events;

  final String baseUrl = 'https://sydney.bgfootballacademy.com';

  Future<void> fetchAllEvents(DateTime selectedDate) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/get-all-schedule-notification'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List eventsData = data['events']; // ✅ Corrected key

        Map<DateTime, List<CalendarEvent>> tempEvents = {};
        for (var eventJson in eventsData) {
          final event = CalendarEvent.fromJson(eventJson);
          final key = DateTime(event.date.year, event.date.month, event.date.day);
          tempEvents.putIfAbsent(key, () => []).add(event);
        }

        _events = tempEvents;
        _selectedDayEvents = _events[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)] ?? [];
      }
    } catch (e) {
      print('Error fetching events: $e');
      _events = {};
      _selectedDayEvents = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  void setSelectedDate(DateTime date) {
    _selectedDayEvents = getEventsForDay(date);
    notifyListeners();
  }
}