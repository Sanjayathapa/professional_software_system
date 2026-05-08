class Course {
  final String id;
  final String name;
  final String code;
  final String description;
  final String instructorId;
  final String instructorName;
  final int creditHours;
  final List<String> enrolledStudentIds;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.creditHours,
    required this.enrolledStudentIds,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      instructorId: json['instructorId'],
      instructorName: json['instructorName'],
      creditHours: json['creditHours'],
      enrolledStudentIds: List<String>.from(json['enrolledStudentIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'creditHours': creditHours,
      'enrolledStudentIds': enrolledStudentIds,
    };
  }
}

