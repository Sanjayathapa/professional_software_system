enum AssignmentStatus {
  pending,
  submitted,
  late,
  graded,
  returned
}

class Assignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String courseId;
  final String courseName;
  final int totalPoints;
  final AssignmentStatus status;
  final int? earnedPoints;
 
  final String? submissionUrl;
  final DateTime? submissionDate;
  final String? feedback;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.courseId,
    required this.courseName,
    required this.totalPoints,
    required this.status,
    this.earnedPoints,
    this.submissionUrl,
    this.submissionDate,
    this.feedback,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      courseId: json['courseId'],
      courseName: json['courseName'],
      totalPoints: json['totalPoints'],
      status: AssignmentStatus.values.firstWhere(
        (e) => e.toString() == 'AssignmentStatus.${json['status']}',
        orElse: () => AssignmentStatus.pending,
      ),
      earnedPoints: json['earnedPoints'],
      submissionUrl: json['submissionUrl'],
      submissionDate: json['submissionDate'] != null
          ? DateTime.parse(json['submissionDate'])
          : null,
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'courseId': courseId,
      'courseName': courseName,
      'totalPoints': totalPoints,
      'status': status.toString().split('.').last,
      'earnedPoints': earnedPoints,
      'submissionUrl': submissionUrl,
      'submissionDate': submissionDate?.toIso8601String(),
      'feedback': feedback,
    };
  }
}


///api model
class Assignments {
  final int id;
  final int courseId;
  final int lecturerId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String links;
  final String courseName;
  final int totalPoints; 
  final AssignmentStatus status; 

  Assignments({
    required this.id,
    required this.courseId,
    required this.lecturerId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.links,
    required this.courseName,
    this.totalPoints = 100, 
    this.status = AssignmentStatus.pending, 
  });

  factory Assignments.fromJson(Map<String, dynamic> json) {
    return Assignments(
      id: json['id'] ?? 0,
    courseId: int.parse(json['course_id'].toString()),
      lecturerId: int.parse(json['lecturer_id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      links: json['links'] ?? '',
      courseName: json['course']?['name'] ?? 'Unknown Course',
    );
  }
}
