  import 'package:musttimetable/models/timetable.dart';
  import 'package:musttimetable/models/timetable_session.dart';

  import '../models/program.dart';
  import '../models/lecturer.dart';
  import '../models/unit.dart';
  import '../models/venue.dart';
  import 'database_helper.dart';

  class DataService {
    // Singleton pattern
    static final DataService _instance = DataService._internal();
    factory DataService() => _instance;
    DataService._internal();
    final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

    Future<Timetable?> getTimetableForProgram(
        String programCode, int year, int semester) async {
      return await _databaseHelper.getTimetableForProgram(
          programCode, year, semester);
    }

    Future<List<TimetableSession>> getLecturerTimetable(
        String lecturerName) async {
      return await _databaseHelper.getLecturerTimetable(lecturerName);
    }

    Future<void> saveTimetables(List<Timetable> timetables) async {
      await _databaseHelper.saveTimetables(timetables);
    }

    // Private lists to store data
    final List<Program> _programs = [];
    final List<Lecturer> _lecturers = [];
    final List<Unit> _units = [];
    final List<Venue> _venues = [];

    DataService._init() {
      // Populate programs (the list of programs from the previous code)
      _programs.addAll([
        Program(
          id: 1,
          code: 'BCS',
          name: 'Bachelor of Computer Science',
          year: 1,
          semester: 1,
          studentCount: 120,
          units: [
            'CIT 3150',
            'CIT 3154',
            'CIT 3153',
            'CCU 3150',
            'CIT 3152',
            'CCF 3100',
            'SMA 3112'
          ],
        ),
        Program(
          id: 2,
          code: 'BCS',
          name: 'Bachelor of Computer Science',
          year: 2,
          semester: 1,
          studentCount: 110,
          units: [
            'CCS 3251',
            'CCS 3255',
            'CCS 3252',
            'CDS 3251',
            'CCS 3250',
            'CCS 3253',
            'CIT 3253'
          ],
        ),
        Program(
          id: 3,
          code: 'BCS',
          name: 'Bachelor of Computer Science',
          year: 3,
          semester: 1,
          studentCount: 95,
          units: [
            'CCS 3353',
            'CCS 3355',
            'CIT 3350',
            'CCS 3354',
            'CCS 3351',
            'CIT 3253',
            'CCF 3351'
          ],
        ),
        Program(
          id: 4,
          code: 'BCS',
          name: 'Bachelor of Computer Science',
          year: 4,
          semester: 1,
          studentCount: 85,
          units: [
            'CIT 3451',
            'CCS 3451',
            'CCF 3451',
            'CDS 3402',
            'CIT 3454',
            'CCF 3456',
            'CIT 3350'
          ],
        ),

        // Bachelor of Data Science (BDS) Programs
        Program(
          id: 5,
          code: 'BDS',
          name: 'Bachelor of Data Science',
          year: 1,
          semester: 1,
          studentCount: 80,
          units: [
            'CDS 3253',
            'CCS 3255',
            'CDS 3251',
            'CCS 3250',
            'SSA 3120',
            'SPS 3255',
            'CDS 3352'
          ],
        ),
        Program(
          id: 6,
          code: 'BDS',
          name: 'Bachelor of Data Science',
          year: 2,
          semester: 1,
          studentCount: 70,
          units: [
            'CDS 3251',
            'CDS 3253',
            'CCS 3251',
            'CCS 3252',
            'CDS 3352',
            'CDS 3353',
            'CIT 3253'
          ],
        ),
        Program(
          id: 7,
          code: 'BDS',
          name: 'Bachelor of Data Science',
          year: 3,
          semester: 2,
          studentCount: 65,
          units: [
            'CDS 3350',
            'CDS 3353',
            'CDS 3351',
            'CDS 3354',
            'CDS 3452',
            'CDS 3451',
            'SMA 3301'
          ],
        ),
        Program(
          id: 8,
          code: 'BDS',
          name: 'Bachelor of Data Science',
          year: 4,
          semester: 1,
          studentCount: 60,
          units: [
            'CDS 3400',
            'CDS 3402',
            'CCS 3454',
            'CDS 3451',
            'CIT 3350',
            'SMA 3154',
            'SMS 3450'
          ],
        ),

        // Bachelor of Business Information Technology (BBIT) Programs
        Program(
          id: 9,
          code: 'BBIT',
          name: 'Bachelor of Business Information Technology',
          year: 1,
          semester: 2,
          studentCount: 110,
          units: [
            'CIT 3150',
            'CIT 3154',
            'CIT 3152',
            'BFC 3125',
            'SMC 3210',
            'CIT 3251',
            'SPS 3250'
          ],
        ),
        Program(
          id: 10,
          code: 'BBIT',
          name: 'Bachelor of Business Information Technology',
          year: 2,
          semester: 2,
          studentCount: 100,
          units: [
            'CIT 3253',
            'CIT 3255',
            'CCS 3350',
            'BFB 3200',
            'CIB 3351',
            'CIT 3358',
            'BFB 3252'
          ],
        ),
        Program(
          id: 11,
          code: 'BBIT',
          name: 'Bachelor of Business Information Technology',
          year: 3,
          semester: 2,
          studentCount: 90,
          units: [
            'BFC 3358',
            'CIT 3451',
            'CIT 3454',
            'CCS 3481',
            'CCF 3450',
            'BFB 3205',
            'SMS 3450'
          ],
        ),
        Program(
          id: 12,
          code: 'BBIT',
          name: 'Bachelor of Business Information Technology',
          year: 4,
          semester: 2,
          studentCount: 80,
          units: [
            'CDS 3402',
            'CIT 3451',
            'CIB 3454',
            'BFB 3252',
            'CIT 3454',
            'SMS 3450',
            'SMA 3154'
          ],
        ),

        // Additional Programs from the document
        Program(
          id: 13,
          code: 'BCJ',
          name: 'Bachelor of Communication',
          year: 1,
          semester: 1,
          studentCount: 75,
          units: [
            'BCJ 3152',
            'BCJ 3153',
            'CCU 3102',
            'CCU 3451',
            'JOO 3456',
            'COMO 3456',
            'COMO 3455'
          ],
        ),
        Program(
          id: 14,
          code: 'BIS',
          name: 'Bachelor of Information Studies',
          year: 1,
          semester: 1,
          studentCount: 70,
          units: [
            'CIS 3151',
            'CIS 3153',
            'CIS 3150',
            'CIS 3251',
            'CIS 3255',
            'CIS 3253',
            'CIS 3250'
          ],
        ),
      ]);

      _lecturers.addAll([
  Lecturer(
    id: 1,
    name: 'W. KARIMI',
    email: 'wkarimi@must.ac.ke',
    units: ['SSA 3120'],
    preferredDays: ['Monday', 'Wednesday', 'Friday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 2,
    name: 'D. KITARIA',
    email: 'dkitaria@must.ac.ke',
    units: ['CIT 3150', 'CCS 3251'],
    preferredDays: ['Monday', 'Tuesday', 'Thursday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 3,
    name: 'S. MAGETO',
    email: 'smageto@must.ac.ke',
    units: ['CIT 3154', 'CIT 3153', 'CIT 3157'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 4,
    name: 'A. IRUNGU',
    email: 'airungu@must.ac.ke',
    units: [
      'CIT 3153',
      'CCS 3255',
      'CDS 3253',
      'CDS 3353',
      'CDS 3350',
      'CDS 3452'
    ],
    preferredDays: ['Monday', 'Wednesday', 'Thursday', 'Friday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 5,
    name: 'M. ASUNTA',
    email: 'masunta@must.ac.ke',
    units: ['CCU 3150', 'CIT 3152'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 6,
    name: 'K. MURUNGI',
    email: 'kmurungi@must.ac.ke',
    units: ['SMC 3212'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 7,
    name: 'DR. J. KITHINJI',
    email: 'jkithinji@must.ac.ke',
    units: ['CDS 3253', 'CCF 3350', 'CCF 3450'],
    preferredDays: ['Monday', 'Wednesday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 8,
    name: 'P. NJUGUNA',
    email: 'pnjuguna@must.ac.ke',
    units: ['CDS 3251', 'CCS 3351', 'CDS 3402', 'CIT 3201'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 9,
    name: 'J. MWITI',
    email: 'jmwiti@must.ac.ke',
    units: ['CCS 3303', 'CCS 3454', 'CCS 3202', 'CIB 3151'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 10,
    name: 'DR. G. GAKII',
    email: 'ggakii@must.ac.ke',
    units: ['SMA 3303', 'SMA 3112', 'CDS 3252'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 11,
    name: 'D. KALUI',
    email: 'dkalui@must.ac.ke',
    units: ['CIT 3152', 'CIT 3153'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 12,
    name: 'DR. J MUTEMBEI',
    email: 'jmutembei@must.ac.ke',
    units: ['SMA 3301', 'CIT 3350'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 13,
    name: 'C. CHEPKOECH',
    email: 'chepkoech@must.ac.ke',
    units: ['SMS 3450'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 14,
    name: 'A. ORTO',
    email: 'aorto@must.ac.ke',
    units: ['CD 3450', 'CCF 3451', 'CDS 3402'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 15,
    name: 'DR. MWADULO',
    email: 'mwadulo@must.ac.ke',
    units: ['CIT 3451', 'CIT 3350', 'CCS 3353'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    preferredTimeSlots: {},
  ),
  Lecturer(
    id: 16,
    name: 'J. JENU',
    email: 'jenu@must.ac.ke',
    units: ['CIT 3350', 'CCS 3451', 'CCS 3355'],
    preferredDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    preferredTimeSlots: {},
  ),
]);
      _units.addAll([
        // Computing and Information Technology Units
        Unit(
          id: 1,
          code: 'CIT 3150',
          name: 'Web Development',
          requiresLab: true,
          hoursPerWeek: 3,
          programs: ['BCS Y1S1', 'BBIT Y1S2'],
          assignedLecturer: 'D. KITARIA',
        ),
        Unit(
          id: 2,
          code: 'CIT 3154',
          name: 'Database Systems',
          requiresLab: true,
          hoursPerWeek: 3,
          programs: ['BCS Y1S1', 'BDS Y1S1'],
          assignedLecturer: 'S. MAGETO',
        ),
        Unit(
          id: 3,
          code: 'CIT 3153',
          name: 'Object-Oriented Programming',
          requiresLab: true,
          hoursPerWeek: 3,
          programs: ['BCS Y1S1'],
          assignedLecturer: 'A. IRUNGU',
        ),
        Unit(
          id: 4,
          code: 'CIT 3152',
          name: 'Operating Systems',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y1S1'],
          assignedLecturer: 'D. KALUI',
        ),
        Unit(
          id: 5,
          code: 'CIT 3157',
          name: 'Advanced Networking',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BBIT Y1S2'],
          assignedLecturer: 'S. MAGETO',
        ),
        Unit(
          id: 6,
          code: 'CIT 3253',
          name: 'Advanced Web Technologies',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y2S1', 'BBIT Y1S2'],
          assignedLecturer: 'E. KANGARU',
        ),
        Unit(
          id: 7,
          code: 'CIT 3255',
          name: 'Software Engineering',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BBIT Y1S2'],
          assignedLecturer: 'D. KIBAARA',
        ),
        Unit(
          id: 8,
          code: 'CIT 3251',
          name: 'Software Design',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BBIT Y1S2'],
          assignedLecturer: 'M. GICHURU',
        ),
        Unit(
          id: 9,
          code: 'CIT 3350',
          name: 'Advanced Software Architecture',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y3S1', 'BBIT Y2S2'],
          assignedLecturer: 'J. JENU',
        ),
        Unit(
          id: 10,
          code: 'CIT 3451',
          name: 'Capstone Project',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y4S1', 'BBIT Y3S2'],
          assignedLecturer: 'M. ASUNTA',
        ),
        Unit(
          id: 11,
          code: 'CIT 3454',
          name: 'Advanced Cybersecurity',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BBIT Y4S2'],
          assignedLecturer: 'E. KANGARU',
        ),

        // Computer Science Units
        Unit(
          id: 12,
          code: 'CCS 3251',
          name: 'Computer Networks',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y2S1', 'BDS Y2S1'],
          assignedLecturer: 'D. KITARIA',
        ),
        Unit(
          id: 13,
          code: 'CCS 3255',
          name: 'Data Communication',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y2S1', 'BDS Y1S1'],
          assignedLecturer: 'A. IRUNGU',
        ),
        Unit(
          id: 14,
          code: 'CCS 3252',
          name: 'Network Security',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y2S1'],
          assignedLecturer: 'DR. S. MUNIALO',
        ),
        Unit(
          id: 15,
          code: 'CCS 3250',
          name: 'Advanced Networking Protocols',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y2S1'],
          assignedLecturer: 'A. ORTO',
        ),
        Unit(
          id: 16,
          code: 'CCS 3353',
          name: 'Advanced Network Design',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y3S1'],
          assignedLecturer: 'DR. MWADULO',
        ),
        Unit(
          id: 17,
          code: 'CCS 3355',
          name: 'Cloud Computing',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y3S1'],
          assignedLecturer: 'K. GOGO',
        ),
        Unit(
          id: 18,
          code: 'CCS 3451',
          name: 'Advanced Cloud Systems',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y4S1'],
          assignedLecturer: 'J. JENU',
        ),
        Unit(
          id: 19,
          code: 'CCS 3454',
          name: 'Distributed Systems',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BBIT Y3S2'],
          assignedLecturer: 'J. MWITI',
        ),

        // Data Science Units
        Unit(
          id: 20,
          code: 'CDS 3253',
          name: 'Data Analysis',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BDS Y1S1', 'BDS Y2S1'],
          assignedLecturer: 'DR. J. KITHINJI',
        ),
        Unit(
          id: 21,
          code: 'CDS 3251',
          name: 'Statistical Methods',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BDS Y1S1', 'BDS Y2S1'],
          assignedLecturer: 'P. NJUGUNA',
        ),
        Unit(
          id: 22,
          code: 'CDS 3350',
          name: 'Advanced Data Mining',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BDS Y3S2'],
          assignedLecturer: 'DR. A. CHEGE',
        ),
        Unit(
          id: 23,
          code: 'CDS 3402',
          name: 'Big Data Analytics',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BDS Y4S1', 'BBIT Y3S2'],
          assignedLecturer: 'P. NJUGUNA',
        ),

        // Other Specialized Units
        Unit(
          id: 24,
          code: 'CCU 3150',
          name: 'Communication Skills',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BCS Y1S1', 'BDS Y1S1'],
          assignedLecturer: 'M. ASUNTA',
        ),
        Unit(
          id: 25,
          code: 'SMC 3212',
          name: 'Strategic Management',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BBIT Y1S2'],
          assignedLecturer: 'K. MURUNGI',
        ),
        Unit(
          id: 26,
          code: 'SSA 3120',
          name: 'System Analysis and Design',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BDS Y1S1'],
          assignedLecturer: 'N. MUGAMBI',
        ),
        Unit(
          id: 27,
          code: 'SPS 3255',
          name: 'Professional Skills',
          requiresLab: false,
          hoursPerWeek: 3,
          programs: ['BDS Y1S1'],
          assignedLecturer: 'P. MWENDA',
        ),
      ]);

      _venues.addAll([
        // Teaching Blocks
        Venue(
          id: 1,
          code: 'TB 08',
          name: 'Teaching Block 8',
          capacity: 60,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 2,
          code: 'TB 05',
          name: 'Teaching Block 5',
          capacity: 45,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 3,
          code: 'TB 16',
          name: 'Teaching Block 16',
          capacity: 55,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 4,
          code: 'TB 06',
          name: 'Teaching Block 6',
          capacity: 50,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 5,
          code: 'TB 11',
          name: 'Teaching Block 11',
          capacity: 45,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 6,
          code: 'TB 02',
          name: 'Teaching Block 2',
          capacity: 40,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 7,
          code: 'TB 14',
          name: 'Teaching Block 14',
          capacity: 40,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 8,
          code: 'TB 10',
          name: 'Teaching Block 10',
          capacity: 40,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 9,
          code: 'TB 03',
          name: 'Teaching Block 3',
          capacity: 40,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 10,
          code: 'TB 01',
          name: 'Teaching Block 1',
          capacity: 35,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 11,
          code: 'THEATRE 3',
          name: 'Theatre 3',
          capacity: 100,
          isLab: false,
          availability: {},
        ),

        // Engineering Blocks
        Venue(
          id: 12,
          code: 'ECB 05',
          name: 'Engineering Computer Lab 5',
          capacity: 40,
          isLab: true,
          availability: {},
        ),
        Venue(
          id: 13,
          code: 'ECB 07',
          name: 'Engineering Block 7',
          capacity: 45,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 14,
          code: 'ECB 12',
          name: 'Engineering Block 12',
          capacity: 35,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 15,
          code: 'ECB 15',
          name: 'Engineering Block 15',
          capacity: 40,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 16,
          code: 'ECB 23',
          name: 'Engineering Block 23',
          capacity: 50,
          isLab: false,
          availability: {},
        ),

        // Other Special Venues
        Venue(
          id: 17,
          code: 'AA 13',
          name: 'Academic Area 13',
          capacity: 35,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 18,
          code: 'AA 19',
          name: 'Academic Area 19',
          capacity: 40,
          isLab: false,
          availability: {},
        ),
        Venue(
          id: 19,
          code: 'ECA 05',
          name: 'Engineering Computer Area 5',
          capacity: 35,
          isLab: true,
          availability: {},
        ),
      ]);
    }
    // Getter methods
    List<Program> getPrograms() => List.from(_programs);
    List<Lecturer> getLecturers() => List.from(_lecturers);
    List<Unit> getUnits() => List.from(_units);
    List<Venue> getVenues() => List.from(_venues);

    // Add methods to add, update, delete items if needed
    void addProgram(Program program) {
      _programs.add(program);
    }

    void addLecturer(Lecturer lecturer) {
      _lecturers.add(lecturer);
    }

    void addUnit(Unit unit) {
      _units.add(unit);
    }

    void addVenue(Venue venue) {
      _venues.add(venue);
    }
  }
