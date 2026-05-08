// import 'package:ciheapp/view/calenderscreen/eventform.dart';
// import 'package:ciheapp/model/calender_event.dart';
// import 'package:ciheapp/provider/calender_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:table_calendar/table_calendar.dart';

// class CalendarScreen extends StatefulWidget {
//   const CalendarScreen({Key? key}) : super(key: key);

//   @override
//   State<CalendarScreen> createState() => _CalendarScreenState();
// }

// class _CalendarScreenState extends State<CalendarScreen> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadEvents();
//     });
//   }

//   Future<void> _loadEvents() async {
//     final calendarProvider =
//         Provider.of<CalendarProvider>(context, listen: false);
//     await calendarProvider.fetchEventsForMonth(
//         _focusedDay.year, _focusedDay.month);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final calendarProvider =
//         Provider.of<CalendarProvider>(context, listen: false);

//     return Scaffold(
//       body: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _focusedDay,
//             calendarFormat: _calendarFormat,
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//               calendarProvider.setSelectedDate(selectedDay);
//             },
//             onFormatChanged: (format) {
//               setState(() {
//                 _calendarFormat = format;
//               });
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//               calendarProvider.fetchEventsForMonth(
//                   focusedDay.year, focusedDay.month); //// this part is to fetched the event fromthe api or dyanmic data and others part are from the package 
//             },
//             eventLoader: (day) {
//               return calendarProvider.getEventsForDay(day);   
//             },
//             calendarStyle: CalendarStyle(
//               markersMaxCount: 3,
//               markerDecoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: _buildEventList(),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//        Navigator.push(context, MaterialPageRoute(
//             builder: (context) => EventForm(selectedDay: _selectedDay!),
//           ));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildEventList() {
//     final calendarProvider = Provider.of<CalendarProvider>(context);
//     final events = calendarProvider.getEventsForDay(_selectedDay!);

//     if (calendarProvider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (events.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.event_busy,
//               size: 80,
//               color: Colors.grey,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No events for this day',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: events.length,
//       padding: const EdgeInsets.all(8),
//       itemBuilder: (context, index) {
//         final event = events[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
//           child: ListTile(
//             leading: _getEventIcon(event.type),
//             title: Text(event.title),
//             subtitle: Text(event.description),
//             trailing: Text(
//               _formatTime(event.startTime),
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             onTap: () {
             
//               _showEventDetails(event);
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _getEventIcon(EventType type) {
//     IconData iconData;
//     Color iconColor;

//     switch (type) {
//       case EventType.assignment:
//         iconData = Icons.assignment;
//         iconColor = Colors.blue;
//         break;
//       case EventType.exam:
//         iconData = Icons.quiz;
//         iconColor = Colors.red;
//         break;
//       case EventType.holiday:
//         iconData = Icons.beach_access;
//         iconColor = Colors.green;
//         break;
//       case EventType.lecture:
//         iconData = Icons.menu_book;
//         iconColor = Colors.orange;
//         break;
//       case EventType.other:
//       default:
//         iconData = Icons.event;
//         iconColor = Colors.purple;
//         break;
//     }

//     return CircleAvatar(
//       backgroundColor: iconColor.withOpacity(0.2),
//       child: Icon(
//         iconData,
//         color: iconColor,
//       ),
//     );
//   }

//   String _formatTime(DateTime dateTime) {
//     final hour = dateTime.hour.toString().padLeft(2, '0');
//     final minute = dateTime.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }

//   void _showEventDetails(CalendarEvent event) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   _getEventIcon(event.type),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       event.title,
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Description',
//                 style: Theme.of(context).textTheme.titleSmall,
//               ),
//               const SizedBox(height: 4),
//               Text(event.description),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   const Icon(Icons.access_time, size: 16),
//                   const SizedBox(width: 8),
//                   Text(
//                     _formatDateTime(event.startTime),
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   if (event.endTime != null) ...[
//                     const Text(' - '),
//                     Text(
//                       _formatDateTime(event.endTime!),
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ],
//               ),
//               if (event.location != null) ...[
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16),
//                     const SizedBox(width: 8),
//                     Text(
//                       event.location!,
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ],
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Close'),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   String _formatDateTime(DateTime dateTime) {
//     final day = dateTime.day.toString().padLeft(2, '0');
//     final month = dateTime.month.toString().padLeft(2, '0');
//     final hour = dateTime.hour.toString().padLeft(2, '0');
//     final minute = dateTime.minute.toString().padLeft(2, '0');
//     return '$day/$month ${hour}:${minute}';
//   }
// }
