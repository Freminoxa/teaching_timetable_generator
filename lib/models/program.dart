class Program {
  final int id;
  final String code;
  final String name;
  final int year;
  final int semester;
  final int studentCount;
  final List<String> units; // Unit codes for this program

  Program({
    required this.id,
    required this.code,
    required this.name,
    required this.year,
    required this.semester,
    required this.studentCount,
    required this.units,
  });

  // Create from JSON
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      year: json['year'],
      semester: json['semester'],
      studentCount: json['studentCount'] ?? 0,
      units: List<String>.from(json['units'] ?? []),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'year': year,
      'semester': semester,
      'studentCount': studentCount,
      'units': units,
    };
  }

  // Get program display name
  String get displayName => '$code Y${year}S$semester';

  // Create a copy with updated fields
  Program copyWith({
    int? id,
    String? code,
    String? name,
    int? year,
    int? semester,
    int? studentCount,
    List<String>? units,
  }) {
    return Program(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      studentCount: studentCount ?? this.studentCount,
      units: units ?? this.units,
    );
  }
}