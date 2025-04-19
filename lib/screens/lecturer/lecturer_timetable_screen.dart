//lib/screens/lecturer/lecturer_timetable_screen.dart
import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../models/timetable_session.dart';
import '../../models/user.dart';
import '../../services/data_service.dart';
import '../../theme/must_theme.dart';
class LecturerTimetableScreen extends StatefulWidget {
  final User lecturer;
  final Map<String, List<TimetableSession>> timetable;

  const LecturerTimetableScreen({
    super.key,
    required this.lecturer,
    required this.timetable,
  });

  @override
  State<LecturerTimetableScreen> createState() => _LecturerTimetableScreenState();
}

class _LecturerTimetableScreenState extends State<LecturerTimetableScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _viewMode = 'week';
  
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
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timetable'),
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
      body: Column(
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
                      'LECTURER TIMETABLE: ${widget.lecturer.name}',
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
        final sessions = widget.timetable[day] ?? [];
        
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
    final sessions = widget.timetable[day] ?? [];
    
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
              const Icon(Icons.location_on,
              size: 14, 
              color: Colors.grey),
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
              const Icon(Icons.people, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(session.program ?? 'Unknown Program'),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.request_page, size: 16),
                  label: const Text('Request Change'),
                  onPressed: () {
                    // Show dialog to request timetable change
                    _showRequestChangeDialog(session);
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
  
  void _showRequestChangeDialog(TimetableSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Timetable Change'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit: ${session.unitCode}'),
            Text('Day: ${session.day}'),
            Text('Time: ${session.timeSlot}'),
            const SizedBox(height: 16),
            const Text('Change Request Type:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Change Day'),
                  selected: false,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: const Text('Change Time'),
                  selected: false,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: const Text('Change Venue'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Preferred Alternative:'),
            const SizedBox(height: 8),
            // Sample day selector
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Preferred Day',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.daysOfWeek
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
              onChanged: (value) {
                // Handle day change
              },
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Reason for Request',
                hintText: 'Please explain why you need this change...',
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
                  content: Text('Change request submitted successfully!'),
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

// Extension to add program field to TimetableSession
extension TimetableSessionExtension on TimetableSession {
  String? get program => null; // This would come from the actual data in a real app
}