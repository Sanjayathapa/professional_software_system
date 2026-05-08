class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String timestamp;
  final String? type; 
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.type,
    this.isRead = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(), 
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      content: json['content'] ?? '',
       timestamp: json['timestamp']?.toString() ?? '',
      type: json['type']?.toString(),
      isRead: json['is_read'] == true || json['is_read'] == 1,
    );
  }

  // static DateTime _parseTime(dynamic timestamp) {

  //   if (timestamp is int) {
  //     return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  //   } else if (timestamp is String) {
  //     try {
  //       return DateTime.parse(timestamp);
  //     } catch (_) {
  //       return DateTime.now(); 
  //     }
  //   }
  //   return DateTime.now(); 
  // }
}
