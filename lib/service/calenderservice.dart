// import 'package:ciheapp/model/calender_event.dart';



// class CalendarService {
  
// final List<CalendarEvent> _mockEvents = [
//   CalendarEvent(
//     id: '1',
//     title: 'Cloud Computing Assignment',
//     description: 'Submit a comparison report on AWS and Azure services.',
//     startTime: DateTime.now().add(const Duration(days: 2)),
//     type: EventType.assignment,
//     courseId: 'ICT202',
//   ),
//   CalendarEvent(
//     id: '2',
//     title: 'Software Engineering Midterm',
//     description: 'Covers SDLC models, Agile, and Design Principles.',
//     startTime: DateTime.now().add(const Duration(days: 5)),
//     endTime: DateTime.now().add(const Duration(days: 5, hours: 2)),
//     type: EventType.exam,
//     location: 'Lab 204',
//     courseId: 'ICT206',
//   ),
//   CalendarEvent(
//     id: '3',
//     title: 'Hackathon Week',
//     description: 'Work on a project using Flutter or React Native.',
//     startTime: DateTime.now().add(const Duration(days: 10)),
//     endTime: DateTime.now().add(const Duration(days: 12)),
//     type: EventType.holiday,
//   ),
// ];

 
//   Future<List<CalendarEvent>> getEventsForMonth(int year, int month) async {
  
//     await Future.delayed(const Duration(seconds: 1));
    
    
//     return _mockEvents.where((event) {
//       return event.startTime.year == year && event.startTime.month == month;
//     }).toList();
//   }


//   Future<CalendarEvent?> getEventById(String eventId) async {
 
//     await Future.delayed(const Duration(milliseconds: 500));
    
//     try {
//       return _mockEvents.firstWhere((event) => event.id == eventId);
//     } catch (e) {
//       return null;
//     }
//   }
// }

