class Unit {
  final int id;
  final String code;
  final String name;
  final bool requiresLab;
  final int hoursPerWeek;
  final List<String> programs; // Program codes where this unit is taught
  final String? assignedLecturer;
  final bool isCommonUnit; // Whether it's shared across multiple programs

  Unit({
    required this.id,
    required this.code,
    required this.name,
    required this.requiresLab,
    required this.hoursPerWeek,
    required this.programs,
    this.assignedLecturer,
    this.isCommonUnit = false,
  });

  // Create from JSON
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      requiresLab: json['requiresLab'] ?? false,
      hoursPerWeek: json['hoursPerWeek'],
      programs: List<String>.from(json['programs'] ?? []),
      assignedLecturer: json['assignedLecturer'],
      isCommonUnit: json['isCommonUnit'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'requiresLab': requiresLab,
      'hoursPerWeek': hoursPerWeek,
      'programs': programs,
      'assignedLecturer': assignedLecturer,
      'isCommonUnit': isCommonUnit,
    };
  }

  // Create a copy with updated fields
  Unit copyWith({
    int? id,
    String? code,
    String? name,
    bool? requiresLab,
    int? hoursPerWeek,
    List<String>? programs,
    String? assignedLecturer,
    bool? isCommonUnit,
  }) {
    return Unit(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      requiresLab: requiresLab ?? this.requiresLab,
      hoursPerWeek: hoursPerWeek ?? this.hoursPerWeek,
      programs: programs ?? this.programs,
      assignedLecturer: assignedLecturer ?? this.assignedLecturer,
      isCommonUnit: isCommonUnit ?? this.isCommonUnit,
    );
  }
}