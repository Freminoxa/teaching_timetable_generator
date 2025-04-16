import 'timetable_session.dart';

class Timetable {
  final int id;
  final String programCode;
  final int programYear;
  final int programSemester;
  final String programName;
  final DateTime generatedDate;
  final List<TimetableSession> sessions;
  final bool isPublished;

  Timetable({
    required this.id,
    required this.programCode,
    required this.programYear,
    required this.programSemester,
    required this.programName,
    required this.generatedDate,
    required this.sessions,
    this.isPublished = false,
  });

  // Create from JSON
  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'],
      programCode: json['programCode'],
      programYear: json['programYear'],
      programSemester: json['programSemester'],
      programName: json['programName'],
      generatedDate: DateTime.parse(json['generatedDate']),
      sessions: (json['sessions'] as List)
          .map((session) => TimetableSession.fromJson(session))
          .toList(),
      isPublished: json['isPublished'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programCode': programCode,
      'programYear': programYear,
      'programSemester': programSemester,
      'programName': programName,
      'generatedDate': generatedDate.toIso8601String(),
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'isPublished': isPublished,
    };
  }

  // Get program display code
  String get programDisplayCode => '$programCode Y${programYear}S$programSemester';

  // Get sessions for a specific day
  List<TimetableSession> getSessionsForDay(String day) {
    return sessions.where((session) => session.day == day).toList();
  }

  // Create a copy with updated fields
  Timetable copyWith({
    int? id,
    String? programCode,
    int? programYear,
    int? programSemester,
    String? programName,
    DateTime? generatedDate,
    List<TimetableSession>? sessions,
    bool? isPublished,
  }) {
    return Timetable(
      id: id ?? this.id,
      programCode: programCode ?? this.programCode,
      programYear: programYear ?? this.programYear,
      programSemester: programSemester ?? this.programSemester,
      programName: programName ?? this.programName,
      generatedDate: generatedDate ?? this.generatedDate,
      sessions: sessions ?? this.sessions,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}