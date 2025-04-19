import 'package:flutter/material.dart';
import '../../theme/must_theme.dart';
import '../../config/app_constants.dart';
import '../../models/user.dart';
import '../../models/timetable_session.dart';
import '../auth/login_screen.dart';
import 'student_timetable_screen.dart';

class StudentDashboard extends StatefulWidget {
  final User user;

  const StudentDashboard({super.key, required this.user});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool _isLoading = true;
  List<TimetableSession> _todaySessions = [];
  List<TimetableSession> _tomorrowSessions = [];
  String _todayDay = 'Monday';
  String _tomorrowDay = 'Tuesday';
  final List<Map<String, dynamic>> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    // Get today's day name
    final now = DateTime.now();
    _todayDay = _getDayName(now.weekday);
    _tomorrowDay = _getDayName(now.weekday % 7 + 1);
    
    // Generate sample timetable data for the student
    final allSessions = _generateSampleTimetable();
    _todaySessions = allSessions[_todayDay] ?? [];
    _tomorrowSessions = allSessions[_tomorrowDay] ?? [];
    
    // Sample announcements
    _announcements.addAll([
      {
        'title': 'Mid-semester Exams Schedule',
        'content': 'Mid-semester exams will begin on March 15th, 2025. The detailed schedule will be available next week.',
        'date': '02 Mar 2025',
        'isUrgent': true,
      },
      {
        'title': 'Library Closure Notice',
        'content': 'The university library will be closed on Saturday for maintenance.',
        'date': '28 Feb 2025',
        'isUrgent': false,
      },
      {
        'title': 'Career Fair Next Month',
        'content': 'Annual career fair will be held from 10th-12th April, 2025 at the University Exhibition Hall.',
        'date': '25 Feb 2025',
        'isUrgent': false,
      },
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  // Generate a sample timetable for the student
  Map<String, List<TimetableSession>> _generateSampleTimetable() {
    Map<String, List<TimetableSession>> timetable = {};

    // Sample units based on student's program
    Map<String, Map<String, dynamic>> units = {
      'CIT 3150': {
        'name': 'Web Development',
        'lecturer': 'D. KITARIA',
        'venue': 'TB 08',
        'isLab': true,
      },
      'CIT 3154': {
        'name': 'Database Systems',
        'lecturer': 'S. MAGETO',
        'venue': 'ECB 05',
        'isLab': true,
      },
      'CIT 3153': {
        'name': 'Object-Oriented Programming',
        'lecturer': 'A. IRUNGU',
        'venue': 'TB 11',
        'isLab': true,
      },
      'CCU 3150': {
        'name': 'Communication Skills',
        'lecturer': 'M. ASUNTA',
        'venue': 'TB 06',
        'isLab': false,
      },
      'CIT 3152': {
        'name': 'Operating Systems',
        'lecturer': 'D. KALUI',
        'venue': 'TB 02',
        'isLab': false,
      },
    };

    // Create a distributed timetable across the week
    int unitIndex = 0;
    for (String day in AppConstants.daysOfWeek) {
      timetable[day] = [];
      
      // Not all days need to have classes - create a realistic schedule
      // Skip some days randomly
      if (day == 'Wednesday' || (day == 'Friday' && unitIndex > 2)) {
        continue; // No classes on this day
      }
      
      // Morning session
      if (unitIndex < units.length) {
        String unitCode = units.keys.elementAt(unitIndex);
        Map<String, dynamic> unitData = units[unitCode]!;
        
        timetable[day]!.add(
          TimetableSession(
            day: day,
            timeSlot: '8AM-11AM',
            unitCode: unitCode,
            unitName: unitData['name'],
            venueCode: unitData['venue'],
            lecturerName: unitData['lecturer'],
            isLab: unitData['isLab'],
            generatedDate: DateTime.now().subtract(const Duration(days: 14)), program: '',
          ),
        );
        
        unitIndex++;
      }
      
      // Afternoon session (only for some days)
      if ((day == 'Monday' || day == 'Thursday') && unitIndex < units.length) {
        String unitCode = units.keys.elementAt(unitIndex);
        Map<String, dynamic> unitData = units[unitCode]!;
        
        timetable[day]!.add(
          TimetableSession(
            day: day,
            timeSlot: '2PM-5PM',
            unitCode: unitCode,
            unitName: unitData['name'],
            venueCode: unitData['venue'],
            lecturerName: unitData['lecturer'],
            isLab: unitData['isLab'],
            generatedDate: DateTime.now().subtract(const Duration(days: 14)), program: '',
          ),
        );
        
        unitIndex++;
      }
    }

    return timetable;
  }

  // Get the day name from weekday number
  String _getDayName(int weekday) {
    // weekday: 1 = Monday, 2 = Tuesday, etc.
    if (weekday >= 1 && weekday <= 5) {
      return AppConstants.daysOfWeek[weekday - 1];
    }
    return 'Monday'; // Default to Monday for weekends in our demo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadData();
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student info card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: MustTheme.lightGreen,
                                  child: Text(
                                    widget.user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: MustTheme.primaryGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.user.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.user.email,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.user.programFullName ?? 'Student',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Current Session: ${AppConstants.currentSession}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Today's classes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today\'s Classes ($_todayDay)',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MustTheme.primaryGreen,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentTimetableScreen(
                                  student: widget.user,
                                ),
                              ),
                            );
                          },
                          child: const Text('View Full Timetable'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (_todaySessions.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No classes scheduled for today',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _todaySessions.length,
                        itemBuilder: (context, index) {
                          return _buildSessionCard(_todaySessions[index]);
                        },
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Tomorrow's classes
                    Text(
                      'Tomorrow\'s Classes ($_tomorrowDay)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MustTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_tomorrowSessions.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No classes scheduled for tomorrow',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tomorrowSessions.length,
                        itemBuilder: (context, index) {
                          return _buildSessionCard(_tomorrowSessions[index]);
                        },
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Announcements
                    const Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MustTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = _announcements[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: announcement['isUrgent'] 
                                ? BorderSide(color: Colors.red.shade300, width: 1) 
                                : BorderSide.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        announcement['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    if (announcement['isUrgent'])
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Urgent',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(announcement['content']),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Posted: ${announcement['date']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
  
  Widget _buildSessionCard(TimetableSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: session.isLab
            ? BorderSide(color: Colors.blue.shade300, width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    session.timeSlot,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (session.isLab)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Lab',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${session.unitCode}: ${session.unitName}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  session.venueCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  session.lecturerName,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}