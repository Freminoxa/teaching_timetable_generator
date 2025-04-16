import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'MUST Timetable Generator';
  static const String currentSession = 'January-May 2025';
  static const String universityName = 'Meru University of Science and Technology';
  static const String schoolName = 'School of Computing and Informatics';
  static const String departmentName = 'Department of Computer Science';

  // Authentication constants
  static const int tokenExpiryDays = 30;
  static const String userRole = 'role';
  static const String adminRole = 'admin';
  static const String lecturerRole = 'lecturer';
  static const String studentRole = 'student';

  // Time slots for the timetable
  static const List<String> timeSlots = [
    '7AM-8AM',
    '8AM-9AM',
    '9AM-10AM',
    '10AM-11AM',
    '11AM-12PM',
    '12PM-1PM',
    '1PM-2PM',
    '2PM-3PM',
    '3PM-4PM',
    '4PM-5PM',
    '5PM-6PM',
    '6PM-7PM',
    '7PM-8PM'
  ];

  // Days of the week
  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  // Timetable generation settings
  static const int maxDailyClasses = 4; // Maximum classes per day for a program
  static const int maxDailyClassesPerLecturer = 3; // Maximum classes per day for a lecturer
  static const int maxConsecutiveClasses = 2; // Maximum consecutive classes
  static const double preferredVenueCapacityRatio = 1.2; // Preferred venue capacity compared to student count
  static const int labSessionDurationHours = 3; // Lab sessions typically last longer
  static const int regularSessionDurationHours = 3; // Regular classes typically last 3 hours
  static const int minDaysBetweenSameUnit = 1; // Minimum days between sessions of the same unit

  // Timetable visual settings
  static const Map<String, Color> dayColors = {
    'Monday': Color(0xFFE3F2FD),    // Light Blue
    'Tuesday': Color(0xFFF1F8E9),   // Light Green
    'Wednesday': Color(0xFFFFF3E0), // Light Orange
    'Thursday': Color(0xFFE8EAF6),  // Light Indigo
    'Friday': Color(0xFFE0F7FA),    // Light Cyan
  };

  static const Map<String, Color> timeColors = {
    'morning': Color(0xFFFFF9C4),   // Light Yellow (Morning sessions)
    'afternoon': Color(0xFFFFECB3), // Light Amber (Afternoon sessions)
    'evening': Color(0xFFFFCCBC),   // Light Deep Orange (Evening sessions)
  };

  // Error messages
  static const String errorTimetableGeneration = 'Failed to generate timetable. Please try again.';
  static const String errorNoPrograms = 'Please select at least one program to generate a timetable.';
  static const String errorNoLecturers = 'No lecturers available for some units. Please assign lecturers first.';
  static const String errorNoVenues = 'No suitable venues found for some sessions. Please add more venues.';
  static const String errorUnassignedUnits = 'Some units are not assigned to any lecturer.';

  // Success messages
  static const String successTimetableGeneration = 'Timetable generated successfully!';
  static const String successTimetablePublication = 'Timetable published successfully!';
  static const String successDataUpdate = 'Data updated successfully!';

  // CSV header fields for imports/exports
  static const List<String> csvLecturerHeaders = ['Name', 'Email', 'Units', 'Preferred Days'];
  static const List<String> csvUnitHeaders = ['Code', 'Name', 'Requires Lab', 'Hours Per Week', 'Programs'];
  static const List<String> csvVenueHeaders = ['Code', 'Name', 'Capacity', 'Is Lab'];
  static const List<String> csvProgramHeaders = ['Code', 'Name', 'Year', 'Semester', 'Student Count', 'Units'];
}