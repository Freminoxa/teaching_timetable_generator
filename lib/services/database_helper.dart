import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/timetable.dart';
import '../models/timetable_session.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('must_timetable.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Timetables table
    await db.execute('''
      CREATE TABLE timetables (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        programCode TEXT,
        programYear INTEGER,
        programSemester INTEGER,
        programName TEXT,
        generatedDate TEXT,
        isPublished INTEGER DEFAULT 0
      )
    ''');

    // Timetable sessions table
    await db.execute('''
      CREATE TABLE timetable_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timetableId INTEGER,
        day TEXT,
        timeSlot TEXT,
        unitCode TEXT,
        unitName TEXT,
        venueCode TEXT,
        lecturerName TEXT,
        isLab INTEGER,
        generatedDate TEXT,
        FOREIGN KEY (timetableId) REFERENCES timetables (id) ON DELETE CASCADE
      )
    ''');
  }

  // Save generated timetables
  Future<void> saveTimetables(List<Timetable> timetables) async {
    final db = await database;
    
    // Use a transaction to ensure atomic save
    await db.transaction((txn) async {
      for (var timetable in timetables) {
        // Insert timetable
        final timetableId = await txn.insert(
          'timetables', 
          {
            'programCode': timetable.programCode,
            'programYear': timetable.programYear,
            'programSemester': timetable.programSemester,
            'programName': timetable.programName,
            'generatedDate': timetable.generatedDate.toIso8601String(),
            'isPublished': timetable.isPublished ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Insert sessions for this timetable
        for (var session in timetable.sessions) {
          await txn.insert(
            'timetable_sessions', 
            {
              'timetableId': timetableId,
              'day': session.day,
              'timeSlot': session.timeSlot,
              'unitCode': session.unitCode,
              'unitName': session.unitName,
              'venueCode': session.venueCode,
              'lecturerName': session.lecturerName,
              'isLab': session.isLab ? 1 : 0,
              'generatedDate': session.generatedDate?.toIso8601String(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  // Fetch timetables for a specific program
  Future<Timetable?> getTimetableForProgram(String programCode, int year, int semester) async {
    final db = await database;
    
    // First, get the timetable
    final timetableList = await db.query(
      'timetables',
      where: 'programCode = ? AND programYear = ? AND programSemester = ?',
      whereArgs: [programCode, year, semester],
    );

    if (timetableList.isEmpty) return null;

    final timetableMap = timetableList.first;

    // Then, get the sessions for this timetable
    final sessionsList = await db.query(
      'timetable_sessions',
      where: 'timetableId = ?',
      whereArgs: [timetableMap['id']],
    );

    // Convert sessions
    final sessions = sessionsList.map((sessionMap) => TimetableSession(
      day: sessionMap['day'] as String,
      timeSlot: sessionMap['timeSlot'] as String,
      unitCode: sessionMap['unitCode'] as String,
      unitName: sessionMap['unitName'] as String,
      venueCode: sessionMap['venueCode'] as String,
      lecturerName: sessionMap['lecturerName'] as String,
      isLab: (sessionMap['isLab'] as int) == 1,
      generatedDate: sessionMap['generatedDate'] != null 
          ? DateTime.parse(sessionMap['generatedDate'] as String) 
          : null,
      program: '', // This field is not stored in the database
    )).toList();

    // Create and return Timetable
    return Timetable(
      id: timetableMap['id'] as int,
      programCode: timetableMap['programCode'] as String,
      programYear: timetableMap['programYear'] as int,
      programSemester: timetableMap['programSemester'] as int,
      programName: timetableMap['programName'] as String,
      generatedDate: DateTime.parse(timetableMap['generatedDate'] as String),
      sessions: sessions,
      isPublished: (timetableMap['isPublished'] as int) == 1,
    );
  }

  // Fetch timetables for a lecturer based on their name
  Future<List<TimetableSession>> getLecturerTimetable(String lecturerName) async {
    final db = await database;
    
    final sessionsList = await db.query(
      'timetable_sessions',
      where: 'lecturerName = ?',
      whereArgs: [lecturerName],
    );

    return sessionsList.map((sessionMap) => TimetableSession(
      day: sessionMap['day'] as String,
      timeSlot: sessionMap['timeSlot'] as String,
      unitCode: sessionMap['unitCode'] as String,
      unitName: sessionMap['unitName'] as String,
      venueCode: sessionMap['venueCode'] as String,
      lecturerName: sessionMap['lecturerName'] as String,
      isLab: (sessionMap['isLab'] as int) == 1,
      generatedDate: sessionMap['generatedDate'] != null 
          ? DateTime.parse(sessionMap['generatedDate'] as String) 
          : null,
      program: '', // This field is not stored in the database
    )).toList();
  }

  // Delete old timetables
  Future<void> deleteOldTimetables() async {
    final db = await database;
    
    // Delete timetables older than 6 months
    final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
    
    await db.delete(
      'timetables',
      where: 'generatedDate < ?',
      whereArgs: [sixMonthsAgo.toIso8601String()],
    );
  }
}