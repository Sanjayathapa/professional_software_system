///for api model of dart
class Courses {
  final int id;
  final String name;
  final String faculty;
  final String teacher;
  final String  batch;
  final String? description;
  final String startDate;
  final String endDate;
  final String schedule;

  Courses({
    required this.id,
    required this.name,
    required this.faculty,

    required this.teacher,
    required this.batch,
    this.description,
    required this.schedule,
    required this.startDate,
    required this.endDate,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
        id: json['id'],
        name: json['name'] ?? '',
        faculty: json['faculty_name'] ?? '',
        teacher: json['teacher_name'] ?? '',
        batch: json['batch'] ?? '',
        description: json['description'] ?? '',
        startDate: json['start_date'] ?? '',
        endDate: json['end_date'] ?? '',
        schedule: json['schedule'] ?? '');
  }
}
