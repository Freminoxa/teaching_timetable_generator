import 'dart:math';
import '../models/lecturer.dart';
import '../models/unit.dart';
import '../models/venue.dart';
import '../models/program.dart';
import '../models/timetable.dart';
import '../models/timetable_session.dart';
import '../config/app_constants.dart';

class TimetableGenerator {
  // Random instance for shuffling
  final Random _random = Random();

  // Generate timetables for selected programs
  Future<List<Timetable>> generateTimetables({
    required List<Program> programs,
    required List<Lecturer> lecturers,
    required List<Unit> units,
    required List<Venue> venues,
  }) async {
    List<Timetable> generatedTimetables = [];

    for (Program program in programs) {
      Timetable timetable = await _generateTimetableForProgram(
        program: program,
        lecturers: lecturers,
        units: units.where((unit) => program.units.contains(unit.code)).toList(),
        venues: venues,
      );
      generatedTimetables.add(timetable);
    }

    return generatedTimetables;
  }

  // Generate timetable for a single program
  Future<Timetable> _generateTimetableForProgram({
    required Program program,
    required List<Lecturer> lecturers,
    required List<Unit> units,
    required List<Venue> venues,
  }) async {
    List<TimetableSession> sessions = [];
    
    // Track allocations to ensure even distribution
    Map<String, int> lecturerAllocations = {};
    Map<String, int> dayAllocations = {};
    Map<String, Map<String, bool>> venueOccupancy = {};
    Map<String, Map<String, bool>> lecturerOccupancy = {};
    
    // Initialize tracking maps
    for (String day in AppConstants.daysOfWeek) {
      dayAllocations[day] = 0;
      venueOccupancy[day] = {};
      lecturerOccupancy[day] = {};
      
      for (String timeSlot in AppConstants.timeSlots) {
        for (Venue venue in venues) {
          venueOccupancy[day]?['${venue.code}_$timeSlot'] = false;
        }
        
        for (Lecturer lecturer in lecturers) {
          lecturerOccupancy[day]?['${lecturer.name}_$timeSlot'] = false;
        }
      }
    }
    
    for (Lecturer lecturer in lecturers) {
      lecturerAllocations[lecturer.name] = 0;
    }
    
    // Shuffle days, units, and time slots to randomize the schedule
    List<String> shuffledDays = List.from(AppConstants.daysOfWeek)..shuffle(_random);
    List<Unit> shuffledUnits = List.from(units)..shuffle(_random);
    
    // First pass: Schedule required lab sessions
    for (Unit unit in shuffledUnits.where((u) => u.requiresLab)) {
      Lecturer? lecturer = _findLecturerForUnit(unit, lecturers);
      if (lecturer == null) continue;
      
      // Lab sessions should be longer, so try to combine consecutive time slots
      bool scheduled = _scheduleUnitSession(
        unit: unit,
        lecturer: lecturer,
        venues: venues.where((v) => v.isLab && v.capacity >= program.studentCount).toList(),
        sessions: sessions,
        program: program,
        dayAllocations: dayAllocations,
        lecturerAllocations: lecturerAllocations,
        venueOccupancy: venueOccupancy,
        lecturerOccupancy: lecturerOccupancy,
        preferLongerSessions: true,
      );
      
      if (!scheduled) {
        // Try with any available lab if matching capacity is not available
        scheduled = _scheduleUnitSession(
          unit: unit,
          lecturer: lecturer,
          venues: venues.where((v) => v.isLab).toList(),
          sessions: sessions,
          program: program,
          dayAllocations: dayAllocations,
          lecturerAllocations: lecturerAllocations,
          venueOccupancy: venueOccupancy,
          lecturerOccupancy: lecturerOccupancy,
          preferLongerSessions: true,
        );
      }
    }
    
    // Second pass: Schedule regular classes
    for (Unit unit in shuffledUnits.where((u) => !u.requiresLab)) {
      Lecturer? lecturer = _findLecturerForUnit(unit, lecturers);
      if (lecturer == null) continue;
      
      bool scheduled = _scheduleUnitSession(
        unit: unit,
        lecturer: lecturer,
        venues: venues.where((v) => !v.isLab && v.capacity >= program.studentCount).toList(),
        sessions: sessions,
        program: program,
        dayAllocations: dayAllocations,
        lecturerAllocations: lecturerAllocations,
        venueOccupancy: venueOccupancy,
        lecturerOccupancy: lecturerOccupancy,
        preferLongerSessions: false,
      );
      
      if (!scheduled) {
        // Try with any available classroom if matching capacity is not available
        scheduled = _scheduleUnitSession(
          unit: unit,
          lecturer: lecturer,
          venues: venues.where((v) => !v.isLab).toList(),
          sessions: sessions,
          program: program,
          dayAllocations: dayAllocations,
          lecturerAllocations: lecturerAllocations,
          venueOccupancy: venueOccupancy,
          lecturerOccupancy: lecturerOccupancy,
          preferLongerSessions: false,
        );
      }
    }
    
    // Create the timetable with the generated sessions
    return Timetable(
      id: DateTime.now().millisecondsSinceEpoch,
      programCode: program.code,
      programYear: program.year,
      programSemester: program.semester,
      programName: program.name,
      generatedDate: DateTime.now(),
      sessions: sessions,
    );
  }
  
  // Find a lecturer assigned to a specific unit
  Lecturer? _findLecturerForUnit(Unit unit, List<Lecturer> lecturers) {
    // First check if there's a lecturer specifically assigned to this unit
    if (unit.assignedLecturer != null) {
      final assignedLecturer = lecturers.where((l) => l.name == unit.assignedLecturer).firstOrNull;
      if (assignedLecturer != null) {
        return assignedLecturer;
      }
    }
    
    // Otherwise, find lecturers who can teach this unit
    final availableLecturers = lecturers.where((l) => l.units.contains(unit.code)).toList();
    
    if (availableLecturers.isEmpty) {
      return null;
    }
    
    // Shuffle lecturers to avoid favoring certain ones
    availableLecturers.shuffle(_random);
    
    // Find the lecturer with the least allocations
    availableLecturers.sort((a, b) {
      int aUnits = 0;
      int bUnits = 0;
      
      // Count how many units each lecturer is teaching from this unit's code
      for (var lecturer in lecturers) {
        if (lecturer.name == a.name && lecturer.units.contains(unit.code)) {
          aUnits++;
        }
        if (lecturer.name == b.name && lecturer.units.contains(unit.code)) {
          bUnits++;
        }
      }
      
      return aUnits.compareTo(bUnits);
    });
    
    return availableLecturers.first;
  }
  
  // Schedule a unit session considering constraints
  bool _scheduleUnitSession({
    required Unit unit,
    required Lecturer lecturer,
    required List<Venue> venues,
    required List<TimetableSession> sessions,
    required Program program,
    required Map<String, int> dayAllocations,
    required Map<String, int> lecturerAllocations,
    required Map<String, Map<String, bool>> venueOccupancy,
    required Map<String, Map<String, bool>> lecturerOccupancy,
    required bool preferLongerSessions,
  }) {
    // Sort days based on current allocations (prefer days with fewer allocations)
    List<String> sortedDays = AppConstants.daysOfWeek.toList();
    sortedDays.sort((a, b) => (dayAllocations[a] ?? 0).compareTo(dayAllocations[b] ?? 0));
    
    // Prefer lecturer's preferred days if available
    if (lecturer.preferredDays.isNotEmpty) {
      sortedDays = [
        ...lecturer.preferredDays,
        ...sortedDays.where((day) => !lecturer.preferredDays.contains(day)),
      ];
    }
    
    // Shuffle timeslots to distribute across different times
    List<String> shuffledTimeSlots = List.from(AppConstants.timeSlots)..shuffle(_random);
    
    // For lab sessions or longer sessions, try to schedule consecutive slots
    if (preferLongerSessions) {
      for (String day in sortedDays) {
        // Skip days that already have too many allocations
        if ((dayAllocations[day] ?? 0) >= (AppConstants.daysOfWeek.length / 2).ceil()) {
          continue;
        }
        
        // Find consecutive available slots
        for (int i = 0; i < AppConstants.timeSlots.length - 2; i++) {
          String slot1 = AppConstants.timeSlots[i];
          String slot2 = AppConstants.timeSlots[i + 1];
          
          if (_isSlotAvailable(day, slot1, lecturer, venues, venueOccupancy, lecturerOccupancy) &&
              _isSlotAvailable(day, slot2, lecturer, venues, venueOccupancy, lecturerOccupancy)) {
            
            // Find an available venue
            Venue? venue = _findAvailableVenue(venues, day, [slot1, slot2], venueOccupancy);
            if (venue != null) {
              // Schedule a 2-hour block
              _createSessionAndUpdateTrackers(
                day: day,
                timeSlot: slot1,
                unit: unit,
                venue: venue,
                lecturer: lecturer,
                sessions: sessions,
                program: program,
                dayAllocations: dayAllocations,
                lecturerAllocations: lecturerAllocations,
                venueOccupancy: venueOccupancy,
                lecturerOccupancy: lecturerOccupancy,
              );
              
              _createSessionAndUpdateTrackers(
                day: day,
                timeSlot: slot2,
                unit: unit,
                venue: venue,
                lecturer: lecturer,
                sessions: sessions,
                program: program,
                dayAllocations: dayAllocations,
                lecturerAllocations: lecturerAllocations,
                venueOccupancy: venueOccupancy,
                lecturerOccupancy: lecturerOccupancy,
              );
              
              return true;
            }
          }
        }
      }
    }
    
    // If no consecutive slots found or not needed, try individual slots
    for (String day in sortedDays) {
      for (String timeSlot in shuffledTimeSlots) {
        if (_isSlotAvailable(day, timeSlot, lecturer, venues, venueOccupancy, lecturerOccupancy)) {
          Venue? venue = _findAvailableVenue(venues, day, [timeSlot], venueOccupancy);
          
          if (venue != null) {
            _createSessionAndUpdateTrackers(
              day: day,
              timeSlot: timeSlot,
              unit: unit,
              venue: venue,
              lecturer: lecturer,
              sessions: sessions,
              program: program,
              dayAllocations: dayAllocations,
              lecturerAllocations: lecturerAllocations,
              venueOccupancy: venueOccupancy,
              lecturerOccupancy: lecturerOccupancy,
            );
            
            return true;
          }
        }
      }
    }
    
    return false;
  }
  
  // Check if a time slot is available for a lecturer and has venues available
  bool _isSlotAvailable(
    String day,
    String timeSlot,
    Lecturer lecturer,
    List<Venue> venues,
    Map<String, Map<String, bool>> venueOccupancy,
    Map<String, Map<String, bool>> lecturerOccupancy,
  ) {
    // Check if lecturer is already occupied
    if (lecturerOccupancy[day]?['${lecturer.name}_$timeSlot'] == true) {
      return false;
    }
    
    // Check if any venue is available
    return venues.any((venue) => 
      venueOccupancy[day]?['${venue.code}_$timeSlot'] == false
    );
  }
  
  // Find an available venue for the given slots
  Venue? _findAvailableVenue(
    List<Venue> venues,
    String day,
    List<String> timeSlots,
    Map<String, Map<String, bool>> venueOccupancy,
  ) {
    // Shuffle venues to avoid favoring certain rooms
    List<Venue> shuffledVenues = List.from(venues)..shuffle(_random);
    
    for (Venue venue in shuffledVenues) {
      bool isAvailable = timeSlots.every((slot) => 
        venueOccupancy[day]?['${venue.code}_$slot'] == false
      );
      
      if (isAvailable) {
        return venue;
      }
    }
    
    return null;
  }
  
  // Create a session and update tracking maps
  void _createSessionAndUpdateTrackers({
    required String day,
    required String timeSlot,
    required Unit unit,
    required Venue venue,
    required Lecturer lecturer,
    required List<TimetableSession> sessions,
    required Program program,
    required Map<String, int> dayAllocations,
    required Map<String, int> lecturerAllocations,
    required Map<String, Map<String, bool>> venueOccupancy,
    required Map<String, Map<String, bool>> lecturerOccupancy,
  }) {
    // Create the session
    TimetableSession session = TimetableSession(
      day: day,
      timeSlot: timeSlot,
      unitCode: unit.code,
      unitName: unit.name,
      venueCode: venue.code,
      lecturerName: lecturer.name,
      isLab: unit.requiresLab,
      generatedDate: DateTime.now(), program: '',
    );
    
    // Add to sessions list
    sessions.add(session);
    
    // Update tracking maps
    dayAllocations[day] = (dayAllocations[day] ?? 0) + 1;
    lecturerAllocations[lecturer.name] = (lecturerAllocations[lecturer.name] ?? 0) + 1;
    venueOccupancy[day]?['${venue.code}_$timeSlot'] = true;
    lecturerOccupancy[day]?['${lecturer.name}_$timeSlot'] = true;
  }
}