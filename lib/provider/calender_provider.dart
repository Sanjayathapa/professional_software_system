// import 'package:ciheapp/model/calender_event.dart';
// import 'package:ciheapp/service/calenderservice.dart';
// import 'package:flutter/material.dart';



// class CalendarProvider with ChangeNotifier {
//   List<CalendarEvent> _events = [];
//   bool _isLoading = false;
//   String? _error;
//   DateTime _selectedDate = DateTime.now();

//   List<CalendarEvent> get events => _events;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   DateTime get selectedDate => _selectedDate;

//   final CalendarService _calendarService = CalendarService();

 
//   void setSelectedDate(DateTime date) {
//     _selectedDate = date;
//     notifyListeners();
//     fetchEventsForMonth(date.year, date.month);
//   }


//   Future<void> fetchEventsForMonth(int year, int month) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final events = await _calendarService.getEventsForMonth(year, month);
//       _events = events;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

 
//   List<CalendarEvent> getEventsForDay(DateTime date) {
//     return _events.where((event) {
//       return event.startTime.year == date.year &&
//           event.startTime.month == date.month &&
//           event.startTime.day == date.day;
//     }).toList();
//   }


//   CalendarEvent? getEventById(String eventId) {
//     try {
//       return _events.firstWhere((event) => event.id == eventId);
//     } catch (e) {
//       return null;
//     }
//   }


//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }

