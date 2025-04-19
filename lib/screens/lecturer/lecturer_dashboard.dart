//lib/screens/lecturer/lecturer_dashboard.dart
import 'package:flutter/material.dart';
import '../../theme/must_theme.dart';
import '../../config/app_constants.dart';
import '../../models/user.dart';
import '../../models/timetable_session.dart';
import '../../services/data_service.dart';
import '../auth/login_screen.dart';
import 'lecturer_timetable_screen.dart';
class LecturerDashboard extends StatefulWidget {
  final User user;

  const LecturerDashboard({super.key, required this.user});

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}
class _LecturerDashboardState extends State<LecturerDashboard> {
  final DataService _dataService = DataService();
  bool _isLoading = true;
  List<TimetableSession> _todaySessions = [];
  List<TimetableSession> _upcomingSessions = [];
  Map<String, List<TimetableSession>> _allSessions = {};
  List<String> _assignedUnits = [];

  @override
  void initState() {
    super.initState();
    _loadLecturerTimetable();
  }
  Future<void> _loadLecturerTimetable() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch lecturer's timetable sessions
      final sessions = await _dataService.getLecturerTimetable(widget.user.name);
      
      // Organize sessions by day
      _allSessions = _organizeTimetableSessions(sessions);
      
      // Get today's sessions
      final now = DateTime.now();
      final today = _getDayName(now.weekday);
      _todaySessions = _allSessions[today] ?? [];
      
      // Get upcoming sessions
      String nextDay = _getNextDayWithClasses(today);
      _upcomingSessions = _allSessions[nextDay] ?? [];
      
      // Extract unique units
      _assignedUnits = _extractUniqueUnits(_allSessions);

      setState(() {
        _isLoading = false;
      });

  } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading timetable: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

   // Organize timetable sessions by day
  Map<String, List<TimetableSession>> _organizeTimetableSessions(List<TimetableSession> sessions) {
    Map<String, List<TimetableSession>> organizedSessions = {};
    
    for (var session in sessions) {
      if (!organizedSessions.containsKey(session.day)) {
        organizedSessions[session.day] = [];
      }
      organizedSessions[session.day]!.add(session);
    }
    
    return organizedSessions;
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
    if (weekday >= 1 && weekday <= 5) {
      return AppConstants.daysOfWeek[weekday - 1];
    }
    return 'Monday'; // Default to Monday for weekends
  }
   // Get the next day that has classes scheduled
  String _getNextDayWithClasses(String today) {
    int todayIndex = AppConstants.daysOfWeek.indexOf(today);
    
    for (int i = 1; i <= AppConstants.daysOfWeek.length; i++) {
      int nextIndex = (todayIndex + i) % AppConstants.daysOfWeek.length;
      String nextDay = AppConstants.daysOfWeek[nextIndex];
      
      if (_allSessions.containsKey(nextDay) && 
          _allSessions[nextDay] != null && 
          _allSessions[nextDay]!.isNotEmpty) {
        return nextDay;
      }
    }
    
    // If no classes found, return next day
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
            onPressed: _loadLecturerTimetable,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLecturerTimetable,
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
                                const Text(
                                  'No classes scheduled for today',
                                  style: TextStyle(
                                    color: Colors.grey,
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
                        const Text(
                          'Upcoming Classes',
                          style: TextStyle(
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
    // Previous implementation remains the same
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
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
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