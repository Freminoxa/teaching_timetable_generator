//lib/models/lecturer.dart
class Lecturer {
  final int id;
  final String name;
  final String email;
  final List<String> units; // Unit codes assigned to lecturer
  final List<String> preferredDays; // Days lecturer prefers to teach
  final Map<String, List<String>> preferredTimeSlots; // Preferred time slots per day

  Lecturer({
    required this.id,
    required this.name,
    required this.email,
    required this.units,
    required this.preferredDays,
    required this.preferredTimeSlots,
  });

  // Create from JSON
  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      units: List<String>.from(json['units'] ?? []),
      preferredDays: List<String>.from(json['preferredDays'] ?? []),
      preferredTimeSlots: Map<String, List<String>>.from(
        (json['preferredTimeSlots'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'units': units,
      'preferredDays': preferredDays,
      'preferredTimeSlots': preferredTimeSlots,
    };
  }

  // Create a copy with updated fields
  Lecturer copyWith({
    int? id,
    String? name,
    String? email,
    List<String>? units,
    List<String>? preferredDays,
    Map<String, List<String>>? preferredTimeSlots,
  }) {
    return Lecturer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      units: units ?? this.units,
      preferredDays: preferredDays ?? this.preferredDays,
      preferredTimeSlots: preferredTimeSlots ?? this.preferredTimeSlots,
    );
  }
}