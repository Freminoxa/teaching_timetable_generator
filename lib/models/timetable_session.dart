class TimetableSession {
  final String day;
  final String timeSlot;
  final String unitCode;
  final String unitName;
  final String venueCode;
  final String lecturerName;
  final bool isLab;
  final DateTime? generatedDate;

  TimetableSession({
    required this.day,
    required this.timeSlot,
    required this.unitCode,
    required this.unitName,
    required this.venueCode,
    required this.lecturerName,
    this.isLab = false,
    this.generatedDate, required String program,
  });

  // Create from JSON
  factory TimetableSession.fromJson(Map<String, dynamic> json) {
    return TimetableSession(
      day: json['day'],
      timeSlot: json['timeSlot'],
      unitCode: json['unitCode'],
      unitName: json['unitName'],
      venueCode: json['venueCode'],
      lecturerName: json['lecturerName'],
      isLab: json['isLab'] ?? false,
      generatedDate: json['generatedDate'] != null 
          ? DateTime.parse(json['generatedDate']) 
          : null, program: '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'timeSlot': timeSlot,
      'unitCode': unitCode,
      'unitName': unitName,
      'venueCode': venueCode,
      'lecturerName': lecturerName,
      'isLab': isLab,
      'generatedDate': generatedDate?.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  TimetableSession copyWith({
    String? day,
    String? timeSlot,
    String? unitCode,
    String? unitName,
    String? venueCode,
    String? lecturerName,
    bool? isLab,
    DateTime? generatedDate,
  }) {
    return TimetableSession(
      day: day ?? this.day,
      timeSlot: timeSlot ?? this.timeSlot,
      unitCode: unitCode ?? this.unitCode,
      unitName: unitName ?? this.unitName,
      venueCode: venueCode ?? this.venueCode,
      lecturerName: lecturerName ?? this.lecturerName,
      isLab: isLab ?? this.isLab,
      generatedDate: generatedDate ?? this.generatedDate, program: '',
    );
  }
}