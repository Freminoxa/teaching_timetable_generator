class Venue {
  final int id;
  final String code;
  final String name;
  final int capacity;
  final bool isLab;
  final Map<String, List<String>> availability; // Availability per day and time slots

  Venue({
    required this.id,
    required this.code,
    required this.name,
    required this.capacity,
    required this.isLab,
    required this.availability,
  });

  // Create from JSON
  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      capacity: json['capacity'],
      isLab: json['isLab'] ?? false,
      availability: Map<String, List<String>>.from(
        (json['availability'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'capacity': capacity,
      'isLab': isLab,
      'availability': availability,
    };
  }

  // Check if venue is available at a specific day and time
  bool isAvailableAt(String day, String timeSlot) {
    if (!availability.containsKey(day)) {
      return false;
    }
    return availability[day]!.contains(timeSlot);
  }

  // Create a copy with updated fields
  Venue copyWith({
    int? id,
    String? code,
    String? name,
    int? capacity,
    bool? isLab,
    Map<String, List<String>>? availability,
  }) {
    return Venue(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      isLab: isLab ?? this.isLab,
      availability: availability ?? this.availability,
    );
  }
}