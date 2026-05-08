
import 'package:flutter/material.dart';
import 'package:principles_ss/provider/api/calendereventprovider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarsScreen extends StatefulWidget {
  const CalendarsScreen({super.key});

  @override
  State<CalendarsScreen> createState() => _CalendarsScreenState();
}

class _CalendarsScreenState extends State<CalendarsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CalendarProvider>(context, listen: false);
      provider.fetchAllEvents(_selectedDay!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);

    return Scaffold(
    
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              provider.setSelectedDate(selectedDay);
            },
            eventLoader: (day) => provider.getEventsForDay(day),
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildEventList(provider)),
        ],
      ),
    );
  }

  Widget _buildEventList(CalendarProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.selectedDayEvents.isEmpty) {
      return const Center(child: Text("No events for this day"));
    }

    return ListView.builder(
      itemCount: provider.selectedDayEvents.length,
      itemBuilder: (context, index) {
        final event = provider.selectedDayEvents[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.event_note),
            title: Text(event.message),
            subtitle: Text('EventTime: ${event.time}',style: TextStyle(color:Colors.green),),
            trailing: Icon(
              event.isSent ? Icons.check_circle : Icons.hourglass_bottom,
              color: event.isSent ? Colors.green : Colors.orange,
            ),
          ),
        );
      },
    );
  }
}
