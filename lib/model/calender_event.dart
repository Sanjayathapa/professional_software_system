class CalendarEvent {
  final DateTime date;
  final String time;
  final String message;
  final String username;
  final bool isSent;

  CalendarEvent({
    required this.date,
    required this.time,
    required this.message,
    required this.username,
    required this.isSent,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      date: DateTime.parse(json['date']),
      time: json['time'],
      message: json['Message'],
      username: json['users'] != null && json['users'].isNotEmpty
          ? json['users'][0]['username']
          : 'Unknown',
      isSent: json['is_sent'].toString() == '1',
    );
  }
}
