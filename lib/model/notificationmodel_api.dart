class NotificationModel {
  final String id;
   final String? title;
  final String message;
  final DateTime timestamp;
  final int isSent;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isSent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['data']['title'] ?? '',
      message: json['data']['message'] ?? '',
          isSent: int.tryParse(json['is_sent'].toString()) ?? 0,
      timestamp: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static NotificationModel fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      isSent: map['isSent'] ?? 0,
    );
  }
}

class NotificationsModel {
  final int id;
  final String? title;
  final String message;
  final DateTime timestamp;
  final int isSent;

  NotificationsModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isSent,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'] ?? '';

    
    final titleMatch = RegExp(r'Title:\s*(.*)').firstMatch(message);
    final extractedTitle = titleMatch != null ? titleMatch.group(1)?.trim() : '';

    return NotificationsModel(
      id: json['id'] ?? 0,
      title: extractedTitle?.isNotEmpty == true ? extractedTitle : '',
      message: message,
      timestamp: DateTime.parse(json['scheduled_at']),
      isSent: int.tryParse(json['is_sent'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isSent': isSent,
    };
  }

  static NotificationsModel fromMap(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      isSent: map['isSent'],
    );
  }
}
