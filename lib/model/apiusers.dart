enum UserRole { student, lecturer, admin, unknown }

class Users {
  final int id;
  final String name;
  final String? profileImageUrl;
  final String email;
  final String? phoneNumber;
  final UserRole role;

  Users({
    required this.id,
    required this.name,
      required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.role = UserRole.unknown,
  });

 factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['username'] ?? 'Unknown',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      profileImageUrl: json['profile_image'] != null && json['profile_image'].toString().isNotEmpty
          ? 'https://sydney.bgfootballacademy.com/${json['profile_image']}'
          : null,
      role: _parseRole(json['role']),
    );
  }

  static UserRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'lecturer':
        return UserRole.lecturer;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.unknown;
    }
  }
}
