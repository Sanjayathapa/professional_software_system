

import 'package:ciheapp/model/apiusers.dart';

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String status;
 
  final String name;
  final String email;
  final String? phoneNumber;
  final UserRole role;
  final String? profileImageUrl;
  final NotificationPreferences notificationPreferences;
  final bool isTwoFactorEnabled;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.status,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.profileImageUrl,
    required this.notificationPreferences,
    this.isTwoFactorEnabled = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['username'] ?? '',
      firstname: json['first_name'] ?? '',
      lastname: json['last_name']?? '',
      status: json['status']??'',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.student,
      ),
      profileImageUrl: json['profileImageUrl'] ?? null,
      notificationPreferences: json['notificationPreferences'] != null
          ? NotificationPreferences.fromJson(json['notificationPreferences'])
          : NotificationPreferences.defaults(),
      isTwoFactorEnabled: json['isTwoFactorEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.toString().split('.').last,
      'profileImageUrl': profileImageUrl,
      'notificationPreferences': notificationPreferences.toJson(),
      'isTwoFactorEnabled': isTwoFactorEnabled,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    UserRole? role,
    String? profileImageUrl,
    NotificationPreferences? notificationPreferences,
    bool? isTwoFactorEnabled,
  }) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
        firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      status: status ?? this.status,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled, 
    );
  }
}

class NotificationPreferences {
  final bool email;
  final bool sms;
  final bool pushNotifications;
  final bool assignmentReminders;
  final bool examReminders;
  final bool collegeNotices;

  NotificationPreferences({
    this.email = true,
    this.sms = true,
    this.pushNotifications = true,
    this.assignmentReminders = true,
    this.examReminders = true,
    this.collegeNotices = true,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      email: json['email'] ?? true,
      sms: json['sms'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      assignmentReminders: json['assignmentReminders'] ?? true,
      examReminders: json['examReminders'] ?? true,
      collegeNotices: json['collegeNotices'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'sms': sms,
      'pushNotifications': pushNotifications,
      'assignmentReminders': assignmentReminders,
      'examReminders': examReminders,
      'collegeNotices': collegeNotices,
    };
  }

  static NotificationPreferences defaults() {
    return NotificationPreferences(
      email: true,
      sms: true,
      pushNotifications: true,
      assignmentReminders: true,
      examReminders: true,
      collegeNotices: true,
    );
  }

  NotificationPreferences copyWith({
    bool? email,
    bool? sms,
    bool? pushNotifications,
    bool? assignmentReminders,
    bool? examReminders,
    bool? collegeNotices,
  }) {
    return NotificationPreferences(
      email: email ?? this.email,
      sms: sms ?? this.sms,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      assignmentReminders: assignmentReminders ?? this.assignmentReminders,
      examReminders: examReminders ?? this.examReminders,
      collegeNotices: collegeNotices ?? this.collegeNotices,
    );
  }
}
