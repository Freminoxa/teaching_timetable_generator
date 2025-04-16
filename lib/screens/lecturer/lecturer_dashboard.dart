import 'package:flutter/material.dart';
import '../../theme/must_theme.dart';
import '../../config/app_constants.dart';
import '../../models/user.dart';
import '../../models/timetable_session.dart';
import '../auth/login_screen.dart';
import 'lecturer_timetable_screen.dart';

class LecturerDashboard extends StatefulWidget {
  final User user;

  const LecturerDashboard({super.key, required this.user});

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  bool _isLoading = true;
  List<TimetableSession> _todaySessions = [];
  List<TimetableSession> _upcomingSessions = [];
  Map<String, List<TimetableSession>> _allSessions = {};
  List<String> _assignedUnits = [];

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
    final today = _getDayName(now.weekday);
    
    // Generate sample timetable data for the lecturer
    _allSessions = _generateSampleTimetable();
    _todaySessions = _allSessions[today] ?? [];
    
    // Get upcoming sessions (next day with classes)
    String nextDay = _getNextDayWithClasses(today);
    _upcomingSessions = _allSessions[nextDay] ?? [];
    
    // Get assigned units
    _assignedUnits = _extractUniqueUnits(_allSessions);

    setState(() {
      _isLoading = false;
    });
  }

  // Generate a sample timetable for the lecturer
  Map<String, List<TimetableSession>> _generateSampleTimetable() {
    Map<String, List<TimetableSession>> timetable = {};

    // Ensure lecturer has assigned units
    List<String> units = widget.user.units ?? [
      'CIT 3150', 
      'CIT 3154', 
      'CCS 3251'
    ];

    // Map of unit codes to names
    Map<String, String> unitNames = {
      'CIT 3150': 'Web Development',
      'CIT 3154': 'Database Systems',
      'CIT 3153': 'Object-Oriented Programming',
      'CCU 3150': 'Communication Skills',
      'CIT 3152': 'Operating Systems',
      'CCS 3251': 'Artificial Intelligence',
      'CCS 3255': 'Machine Learning',
      'CDS 3253': 'Data Mining',
    };

    // Sample venues
    List<String> venues = ['TB 08', 'TB 05', 'ECB 05', 'TB 16', 'TB 06'];

    // Sample student groups
    List<String> programs = [
      'BCS Y1S1', 
      'BCS Y2S1', 
      'BCS Y3S1', 
      'BDS Y1S1', 
      'BDS Y2S1'
    ];

    // Create distributed sessions throughout the week
    for (int i = 0; i < units.length; i++) {
      // Get unit info
      String unitCode = units[i];
      String unitName = unitNames[unitCode] ?? 'Unknown Unit';
      
      // Assign to a day (distribute evenly)
      String day = AppConstants.daysOfWeek[i % AppConstants.daysOfWeek.length];
      
      // Determine if it's a lab session
      bool isLab = i % 2 == 0;
      
      // Assign a time slot
      String timeSlot = isLab 
          ? '2PM-5PM'  // Labs in afternoon
          : (i % 2 == 0 ? '8AM-11AM' : '11AM-2PM'); // Morning/midday for regular classes
          
      // Assign venue and program
      String venue = venues[i % venues.length];
      String program = programs[i % programs.length];
      
      // Create the session
      TimetableSession session = TimetableSession(
        day: day,
        timeSlot: timeSlot,
        unitCode: unitCode,
        unitName: unitName,
        venueCode: venue,
        lecturerName: widget.user.name,
        isLab: isLab,
        generatedDate: DateTime.now().subtract(const Duration(days: 7)),
        // Additional fields we'll add for the lecturer view
        program: program,
      );
      
      // Add to timetable
      if (!timetable.containsKey(day)) {
        timetable[day] = [];
      }
      timetable[day]!.add(session);
    }

    return timetable;
  }

  // Extract all unique units from timetable
  List<String> _extractUniqueUnits(Map<String, List<TimetableSession>> timetable) {
    Set<String> units = {};
    
    for (var day in timetable.keys) {
      for (var session in timetable[day]!) {
        units.add(session.unitCode);
      }
    }
    
    return units.toList();
  }

  // Get the day name from weekday number
  String _getDayName(int weekday) {
    // weekday: 1 = Monday, 2 = Tuesday, etc.
    if (weekday >= 1 && weekday <= 5) {
      return AppConstants.daysOfWeek[weekday - 1];
    }
    return 'Monday'; // Default to Monday for weekends in our demo
  }
  
  // Get the next day that has classes scheduled
  String _getNextDayWithClasses(String today) {
    // Find today's index
    int todayIndex = AppConstants.daysOfWeek.indexOf(today);
    
    // Check subsequent days
    for (int i = 1; i <= AppConstants.daysOfWeek.length; i++) {
      int nextIndex = (todayIndex + i) % AppConstants.daysOfWeek.length;
      String nextDay = AppConstants.daysOfWeek[nextIndex];
      
      if (_allSessions.containsKey(nextDay) && 
          _allSessions[nextDay] != null && 
          _allSessions[nextDay]!.isNotEmpty) {
        return nextDay;
      }
    }
    
    // If no classes found, return next day anyway
    int nextIndex = (todayIndex + 1) % AppConstants.daysOfWeek.length;
    return AppConstants.daysOfWeek[nextIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturer Dashboard'),
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
                    // Lecturer info card
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
                                        'Lecturer, Department of ${AppConstants.departmentName}',
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
                            const Divider(),
                            const SizedBox(height: 8),
                            const Text(
                              'Assigned Units',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _assignedUnits.map((unit) => Chip(
                                label: Text(unit),
                                backgroundColor: MustTheme.lightGreen,
                                labelStyle: const TextStyle(
                                  color: MustTheme.primaryGreen,
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Today's classes
                    const Text(
                      'Today\'s Classes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MustTheme.primaryGreen,
                      ),
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
                    
                    // Upcoming classes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming Classes',
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
                                builder: (_) => LecturerTimetableScreen(
                                  lecturer: widget.user,
                                  timetable: _allSessions,
                                ),
                              ),
                            );
                          },
                          child: const Text('View Full Timetable'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _upcomingSessions.length,
                      itemBuilder: (context, index) {
                        return _buildSessionCard(
                          _upcomingSessions[index], 
                          showDay: true,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MustTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildActionCard(
                          title: 'Report Issue',
                          icon: Icons.report_problem,
                          color: Colors.orange,
                          onTap: () {
                            // Show issue reporting dialog
                            _showReportIssueDialog();
                          },
                        ),
                        _buildActionCard(
                          title: 'Download Timetable',
                          icon: Icons.download,
                          color: Colors.green,
                          onTap: () {
                            // Download timetable as PDF
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading timetable...'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          title: 'Request Change',
                          icon: Icons.edit_calendar,
                          color: Colors.blue,
                          onTap: () {
                            // Show change request dialog
                          },
                        ),
                        _buildActionCard(
                          title: 'View Profile',
                          icon: Icons.person,
                          color: Colors.purple,
                          onTap: () {
                            // Navigate to profile screen
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
  
  Widget _buildSessionCard(TimetableSession session, {bool showDay = false}) {
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
                if (showDay) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppConstants.dayColors[session.day] ?? Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      session.day,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
                const Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  session.program ?? 'Unknown Program',
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
  
  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showReportIssueDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Timetable Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Issue Type:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Venue Conflict'),
                  selected: false,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: const Text('Time Clash'),
                  selected: false,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: const Text('Other'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Issue Description',
                hintText: 'Please describe the issue...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Issue reported successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
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