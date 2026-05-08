class Enrollment {
  final int id;
  final String status;
  final String courseName;
  final String studentName;

  Enrollment({
    required this.id,
    required this.status,
    required this.courseName,
    required this.studentName,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    final course = json['course'];
    final student = json['student'];
    return Enrollment(
      id: json['id'] ?? 0,
      status: json['status'],
      courseName: course != null
          ? course['name'] ?? 'Unknown Course'
          : 'Unknown Course',
      studentName: student != null
          ? student['first_name'] ?? 'Unknown Student'
          : 'Unknown Student',
    );
  }
}

class Course {
  final int id;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String schedule;
  final String createdBy;
  final String facultyName;
  final String teacherName;
  final String batch;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.schedule,
    required this.createdBy,
    required this.facultyName,
    required this.teacherName,
    required this.batch,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Name',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      schedule: json['schedule'] ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      facultyName: json['faculty_name'] ?? 'Unknown Faculty',
      teacherName: json['teacher_name'] ?? 'Unknown Teacher',
      batch: json['batch'] ?? 'Unknown Batch',
    );
  }
}

class Group {
  final int id;
  final int userid;
  final int groupid;
  final String groupname;
  final String courseName;
  final String? facultyName;
  final String? batch;
 final String? teacherName;
  final List<GroupMember> membersNames;

  Group({
    required this.id,
    required this.groupid,
    required this.userid,
    this.batch,
    this.facultyName,
    this.teacherName,
    required this.groupname,
    required this.courseName,
    required this.membersNames,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
     final courseJson = json['course'];
  final course = courseJson != null ? Course.fromJson(courseJson) : null;
    final members = json['members'] as List<dynamic> ?? [];
 final faculty = json['faculty_name'];
    final teacher = json['teacher_name'];
    final batch = json['batch'];
    final membersNames = members.map<GroupMember>((member) {
      final user = member['user'];
      final mId = member['id'] != null ? int.tryParse(member['id'].toString()) ?? 0 : 0;
      final groupId = member['group_id'] != null ? int.tryParse(member['group_id'].toString()) ?? 0 : 0;
      final userId = member['user_id'] != null ? int.tryParse(member['user_id'].toString()) ?? 0 : 0;

      final id = user['id'] ?? 0;

      final firstName = user['first_name'] ?? '';
      final lastName = user['last_name'] ?? '';
      final name = '$firstName $lastName'.trim();
      return GroupMember(mId: mId, groupId: groupId, userId: userId, name: name);
    }).toList();

    return Group(
      id: json['id'] ?? 0,
      userid: json['user_id'] ?? 0,
      groupid:json['group_id'] ?? 0,
      
      groupname: json['group_name'] ?? '',
    courseName: course?.name ?? 'Unknown Course',
    facultyName: course?.facultyName,
    teacherName: course?.teacherName,
    batch: course?.batch,
      membersNames: membersNames,
    );
  }
}

class GroupMember {
  final int mId;
  final int groupId;
  final int userId;
  final String name;

  GroupMember({
    required this.mId,
    required this.groupId,
    required this.userId,
    required this.name,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final mid = json['id'] ?? 0; 
    final groupId = json['group_id']?? 0;
    final userId = json['user_id']?? 0;
    final firstName = user['first_name'] ?? '';
    final lastName = user['last_name'] ?? '';
    final name = '$firstName $lastName'.trim();
    return GroupMember(mId: mid, groupId: groupId, userId: userId, name: name);
  }
}
