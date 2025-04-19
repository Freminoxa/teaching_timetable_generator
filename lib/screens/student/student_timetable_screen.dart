import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../models/timetable_session.dart';
import '../../models/user.dart';
import '../../theme/must_theme.dart';

class StudentTimetableScreen extends StatefulWidget {
  final User student;

  const StudentTimetableScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentTimetableScreen> createState() => _StudentTimetableScreenState();
}

class _StudentTimetableScreenState extends State<StudentTimetableScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _viewMode = 'week';
  bool _isLoading = true;
  Map<String, List<TimetableSession>> _timetable = {};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.daysOfWeek.length,
      vsync: this,
    );
    
    // Set initial tab to current day if it has classes
    final now = DateTime.now();
    int weekday = now.weekday;
    if (weekday <= 5) { // Monday to Friday (1-5)
      _tabController.index = weekday - 1;
    }
    
    _loadTimetable();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadTimetable() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate sample timetable
    _timetable = _generateSampleTimetable();
    
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable: ${widget.student.programFullName ?? ''}'),
        bottom: _viewMode == 'day' ? TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: AppConstants.daysOfWeek.map((day) => Tab(text: day)).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ) : null,
        actions: [
          IconButton(
            icon: Icon(_viewMode == 'week' ? Icons.view_day : Icons.view_week),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == 'week' ? 'day' : 'week';
              });
            },
            tooltip: _viewMode == 'week' ? 'Day View' : 'Week View',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Download timetable as PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloading timetable...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Download PDF',
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Timetable header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: MustTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          AppConstants.universityName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          AppConstants.schoolName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'TIMETABLE: ${widget.student.programFullName ?? 'STUDENT'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          AppConstants.currentSession,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Timetable content
              Expanded(
                child: _viewMode == 'week' 
                    ? _buildWeekView() 
                    : TabBarView(
                        controller: _tabController,
                        children: AppConstants.daysOfWeek.map((day) {
                          return _buildDayContent(day);
                        }).toList(),
                      ),
              ),
            ],
          ),
    );
  }
  
  Widget _buildWeekView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppConstants.daysOfWeek.length,
      itemBuilder: (context, index) {
        final day = AppConstants.daysOfWeek[index];
        final sessions = _timetable[day] ?? [];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppConstants.dayColors[day] ?? MustTheme.lightGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${sessions.length} session${sessions.length != 1 ? "s" : ""}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            if (sessions.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 24),
                child: Text(
                  'No classes scheduled for $day',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Column(
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sessions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return _buildSessionTile(sessions[index]);
                      },
                    ),
                  ),
                ],
              ),
            
            if (index < AppConstants.daysOfWeek.length - 1)
              const Divider(height: 32),
          ],
        );
      },
    );
  }
  
  Widget _buildDayContent(String day) {
    final sessions = _timetable[day] ?? [];
    
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No classes scheduled for $day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildSessionTile(sessions[index], expanded: true),
        );
      },
    );
  }
  
  Widget _buildSessionTile(TimetableSession session, {bool expanded = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 80,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          session.timeSlot,
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text(
        '${session.unitCode}: ${session.unitName}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                session.venueCode,
                style: TextStyle(
                  color: session.isLab ? Colors.blue[700] : null,
                  fontWeight: session.isLab ? FontWeight.w500 : null,
                ),
              ),
              if (session.isLab) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Lab',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(session.lecturerName),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.notifications, size: 16),
                  label: const Text('Set Reminder'),
                  onPressed: () {
                    // Show dialog to set reminder
                    _showSetReminderDialog(session);
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.report_problem_outlined, size: 16),
                  label: const Text('Report Issue'),
                  onPressed: () {
                    // Show dialog to report issue
                    _showReportIssueDialog(session);
                  },
                ),
              ],
            ),
          ],
        ],
      ),
      isThreeLine: true,
    );
  }
  
  void _showSetReminderDialog(TimetableSession session) {
    final TextEditingController noteController = TextEditingController();
    int reminderMinutes = 30; // Default reminder time
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Set Class Reminder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Class: ${session.unitCode}'),
                Text('Day: ${session.day}'),
                Text('Time: ${session.timeSlot}'),
                const SizedBox(height: 16),
                const Text('Reminder Time:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('15 min'),
                      selected: reminderMinutes == 15,
                      onSelected: (selected) {
                        setState(() {
                          reminderMinutes = 15;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('30 min'),
                      selected: reminderMinutes == 30,
                      onSelected: (selected) {
                        setState(() {
                          reminderMinutes = 30;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('1 hour'),
                      selected: reminderMinutes == 60,
                      onSelected: (selected) {
                        setState(() {
                          reminderMinutes = 60;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Add Note (Optional)',
                    hintText: 'E.g., Bring assignment, prepare questions, etc.',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
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
                  // Set reminder logic would go here
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reminder set for ${session.unitCode} - $reminderMinutes minutes before class.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Set Reminder'),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _showReportIssueDialog(TimetableSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Timetable Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit: ${session.unitCode}'),
            Text('Day: ${session.day}'),
            Text('Time: ${session.timeSlot}'),
            const SizedBox(height: 16),
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
}