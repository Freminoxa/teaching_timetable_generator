import 'package:flutter/material.dart';
import '../../../theme/must_theme.dart';
import '../../../config/app_constants.dart';
import '../../../models/timetable_session.dart';

class ViewTimetableScreen extends StatefulWidget {
  final String programName;

  const ViewTimetableScreen({
    super.key,
    required this.programName,
  });

  @override
  State<ViewTimetableScreen> createState() => _ViewTimetableScreenState();
}

class _ViewTimetableScreenState extends State<ViewTimetableScreen> {
  bool _isLoading = true;
  String _viewMode = 'week'; // 'week' or 'day'
  String _selectedDay = AppConstants.daysOfWeek[0];
  bool _showFilters = false;
  final List<String> _filteredVenues = [];
  final List<String> _filteredLecturers = [];
  
  // Sample timetable data - would be fetched from database in real app
  late Map<String, List<TimetableSession>> _timetableData;

  @override
  void initState() {
    super.initState();
    _loadTimetableData();
  }

  Future<void> _loadTimetableData() async {
    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate sample timetable data
    _timetableData = _generateSampleTimetableData();
    
    setState(() {
      _isLoading = false;
    });
  }
  
  // Generate sample timetable data
  Map<String, List<TimetableSession>> _generateSampleTimetableData() {
    Map<String, List<TimetableSession>> data = {};
    
    // Define sample units, lecturers and venues for the program
    final List<Map<String, String>> units = [
      {'code': 'CIT 3150', 'name': 'Web Development', 'lecturer': 'D. KITARIA', 'isLab': 'true'},
      {'code': 'CIT 3154', 'name': 'Database Systems', 'lecturer': 'S. MAGETO', 'isLab': 'true'},
      {'code': 'CIT 3153', 'name': 'Object-Oriented Programming', 'lecturer': 'A. IRUNGU', 'isLab': 'true'},
      {'code': 'CCU 3150', 'name': 'Communication Skills', 'lecturer': 'M. ASUNTA', 'isLab': 'false'},
      {'code': 'CIT 3152', 'name': 'Operating Systems', 'lecturer': 'D. KALUI', 'isLab': 'false'},
    ];
    
    final List<String> venues = ['TB 08', 'TB 05', 'ECB 05', 'TB 16', 'TB 06', 'TB 11'];
    
    // Time slots for typical class sessions (morning, afternoon, evening)
    final List<String> timeSlots = [
      '8AM-11AM', // Morning
      '11AM-2PM', // Mid-day
      '2PM-5PM',  // Afternoon
    ];
    
    // For each day, create random sessions distributed evenly
    for (String day in AppConstants.daysOfWeek) {
      data[day] = [];
      
      // Assign each unit to a different day of the week where possible
      int unitIndex = AppConstants.daysOfWeek.indexOf(day) % units.length;
      
      // For the distributed timetable, not all days need all slots filled
      // We'll pseudo-randomly decide which slots to use
      List<String> daySlots = List.from(timeSlots);
      daySlots.shuffle();
      
      // Limit to 1-2 sessions per day to make the timetable balanced
      int sessionsPerDay = 1 + (AppConstants.daysOfWeek.indexOf(day) % 2);
      daySlots = daySlots.take(sessionsPerDay).toList();
      
      for (String timeSlot in daySlots) {
        final Map<String, String> unit = units[unitIndex];
        final String venue = venues[(unitIndex + AppConstants.daysOfWeek.indexOf(day)) % venues.length];
        
        data[day]!.add(
          TimetableSession(
            day: day,
            timeSlot: timeSlot,
            unitCode: unit['code']!,
            unitName: unit['name']!,
            venueCode: venue,
            lecturerName: unit['lecturer']!,
            isLab: unit['isLab'] == 'true',
            generatedDate: DateTime.now(), program: 'BCS Y1S1',
          ),
        );
        
        // Move to next unit
        unitIndex = (unitIndex + 1) % units.length;
      }
    }
    
    return data;
  }
  
  List<TimetableSession> _getFilteredSessions(String day) {
    List<TimetableSession> sessions = _timetableData[day] ?? [];
    
    if (_filteredVenues.isNotEmpty) {
      sessions = sessions.where(
        (session) => _filteredVenues.contains(session.venueCode)
      ).toList();
    }
    
    if (_filteredLecturers.isNotEmpty) {
      sessions = sessions.where(
        (session) => _filteredLecturers.contains(session.lecturerName)
      ).toList();
    }
    
    return sessions;
  }
  
  // Get list of all venues in the timetable
  List<String> get _allVenues {
    Set<String> venues = {};
    
    for (var day in _timetableData.keys) {
      for (var session in _timetableData[day]!) {
        venues.add(session.venueCode);
      }
    }
    
    return venues.toList()..sort();
  }
  
  // Get list of all lecturers in the timetable
  List<String> get _allLecturers {
    Set<String> lecturers = {};
    
    for (var day in _timetableData.keys) {
      for (var session in _timetableData[day]!) {
        lecturers.add(session.lecturerName);
      }
    }
    
    return lecturers.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable: ${widget.programName}'),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
            tooltip: 'Share',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // View mode selector
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment<String>(
                            value: 'week',
                            label: Text('Week View'),
                            icon: Icon(Icons.calendar_view_week),
                          ),
                          ButtonSegment<String>(
                            value: 'day',
                            label: Text('Day View'),
                            icon: Icon(Icons.calendar_view_day),
                          ),
                        ],
                        selected: {_viewMode},
                        onSelectionChanged: (Set<String> selection) {
                          setState(() {
                            _viewMode = selection.first;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      if (_viewMode == 'day')
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Select Day',
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            value: _selectedDay,
                            items: AppConstants.daysOfWeek
                                .map((day) => DropdownMenuItem(
                                      value: day,
                                      child: Text(day),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedDay = value;
                                });
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Filters
                if (_showFilters)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter By:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            // Venue filters
                            ..._allVenues.map((venue) => FilterChip(
                              label: Text(venue),
                              selected: _filteredVenues.contains(venue),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _filteredVenues.add(venue);
                                  } else {
                                    _filteredVenues.remove(venue);
                                  }
                                });
                              },
                            )),
                            
                            // Lecturer filters
                            ..._allLecturers.map((lecturer) => FilterChip(
                              label: Text(lecturer),
                              selected: _filteredLecturers.contains(lecturer),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _filteredLecturers.add(lecturer);
                                  } else {
                                    _filteredLecturers.remove(lecturer);
                                  }
                                });
                              },
                              backgroundColor: Colors.blue[50],
                              selectedColor: Colors.blue[100],
                            )),
                          ],
                        ),
                        
                        // Clear filters button
                        if (_filteredVenues.isNotEmpty || _filteredLecturers.isNotEmpty)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              icon: const Icon(Icons.clear_all),
                              label: const Text('Clear Filters'),
                              onPressed: () {
                                setState(() {
                                  _filteredVenues.clear();
                                  _filteredLecturers.clear();
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                
                // Timetable header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                            'TIMETABLE: ${widget.programName}',
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
                      : _buildDayView(_selectedDay),
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
        final sessions = _getFilteredSessions(day);
        
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
                        final session = sessions[index];
                        
                        return _buildSessionTile(session);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            
            if (index < AppConstants.daysOfWeek.length - 1)
              const Divider(height: 32),
          ],
        );
      },
    );
  }
  
  Widget _buildDayView(String day) {
    final sessions = _getFilteredSessions(day);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.dayColors[day] ?? MustTheme.lightGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          
          if (sessions.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
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
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildSessionTile(session, expanded: true),
                  );
                },
              ),
            ),
        ],
      ),
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
                OutlinedButton.icon(
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
                  label: const Text('Lecturer Unavailable'),
                  selected: false,
                  onSelected: (_) {},
                ),
                ChoiceChip(
                  label: const Text('Time Clash'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Additional Details',
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
              // Submit issue report
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