enum UserRole { admin, lecturer, student }

class User {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final String? programCode; // Only for students
  final int? programYear;    // Only for students
  final int? programSemester; // Only for students
  final List<String>? units;  // Only for lecturers

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.programCode,
    this.programYear,
    this.programSemester,
    this.units,
  });

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.student,
      ),
      programCode: json['programCode'],
      programYear: json['programYear'],
      programSemester: json['programSemester'],
      units: json['units'] != null ? List<String>.from(json['units']) : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'programCode': programCode,
      'programYear': programYear,
      'programSemester': programSemester,
      'units': units,
    };
  }

  // Create a copy with updated fields
  User copyWith({
    int? id,
    String? name,
    String? email,
    UserRole? role,
    String? programCode,
    int? programYear,
    int? programSemester,
    List<String>? units,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      programCode: programCode ?? this.programCode,
      programYear: programYear ?? this.programYear,
      programSemester: programSemester ?? this.programSemester,
      units: units ?? this.units,
    );
  }

  // Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  // Check if user is lecturer
  bool get isLecturer => role == UserRole.lecturer;

  // Check if user is student
  bool get isStudent => role == UserRole.student;

  // Get program full name for students
  String? get programFullName {
    if (isStudent && programCode != null && programYear != null && programSemester != null) {
      return '$programCode Y${programYear}S$programSemester';
    }
    return null;
  }
}