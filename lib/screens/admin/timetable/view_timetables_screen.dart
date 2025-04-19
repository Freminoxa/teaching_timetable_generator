import 'package:flutter/material.dart';
import '../../../theme/must_theme.dart';
import 'generate_timetable_screen.dart';
import 'view_timetable_screen.dart';

class ViewTimetablesScreen extends StatefulWidget {
  const ViewTimetablesScreen({super.key});

  @override
  State<ViewTimetablesScreen> createState() => _ViewTimetablesScreenState();
}

class _ViewTimetablesScreenState extends State<ViewTimetablesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _selectedFilter = 'all';

  // Sample timetables data
  late List<Map<String, dynamic>> _timetables;
  List<Map<String, dynamic>> _filteredTimetables = [];

  @override
  void initState() {
    super.initState();
    _loadTimetables();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTimetables() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    // Sample data
    _timetables = [
      {
        'id': 1,
        'program': 'BCS Y1S1',
        'name': 'Bachelor of Computer Science',
        'year': 1,
        'semester': 1,
        'date': '15 Jan 2025',
        'status': 'published',
      },
      {
        'id': 2,
        'program': 'BCS Y2S1',
        'name': 'Bachelor of Computer Science',
        'year': 2,
        'semester': 1,
        'date': '15 Jan 2025',
        'status': 'published',
      },
      {
        'id': 3,
        'program': 'BCS Y3S1',
        'name': 'Bachelor of Computer Science',
        'year': 3,
        'semester': 1,
        'date': '15 Jan 2025',
        'status': 'draft',
      },
      {
        'id': 4,
        'program': 'BCS Y4S1',
        'name': 'Bachelor of Computer Science',
        'year': 4,
        'semester': 1,
        'date': '15 Jan 2025',
        'status': 'published',
      },
      {
        'id': 5,
        'program': 'BDS Y1S1',
        'name': 'Bachelor of Data Science',
        'year': 1,
        'semester': 1,
        'date': '15 Jan 2025',
        'status': 'published',
      },
      {
        'id': 6,
        'program': 'BDS Y2S1',
        'name': 'Bachelor of Data Science',
        'year': 2,
        'semester': 1,
        'date': '15 Jan 2025',
        'status': 'draft',
      },
    ];

    _filterTimetables();

    setState(() {
      _isLoading = false;
    });
  }

  void _filterTimetables() {
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      _filteredTimetables = _timetables.where((timetable) {
        return timetable['program'].toLowerCase().contains(query) ||
            timetable['name'].toLowerCase().contains(query);
      }).toList();
    } else {
      _filteredTimetables = List.from(_timetables);
    }

    // Apply status filter
    if (_selectedFilter != 'all') {
      _filteredTimetables = _filteredTimetables
          .where((timetable) => timetable['status'] == _selectedFilter)
          .toList();
    }
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'Are you sure you want to delete this timetable? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteTimetable(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteTimetable(int id) {
    setState(() {
      _timetables.removeWhere((timetable) => timetable['id'] == id);
      _filterTimetables();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Timetable deleted successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _publishTimetable(int id) {
    setState(() {
      final index = _timetables.indexWhere((timetable) => timetable['id'] == id);
      if (index != -1) {
        _timetables[index]['status'] = 'published';
        _filterTimetables();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Timetable published successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Timetables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadTimetables();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search timetables...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filterTimetables();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filterTimetables();
                    });
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text('Filter:'),
                      const SizedBox(width: 8),
                      _buildFilterChip('All', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Published', 'published'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Drafts', 'draft'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Timetables list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTimetables.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredTimetables.length,
                        itemBuilder: (context, index) {
                          final timetable = _filteredTimetables[index];
                          final bool isDraft = timetable['status'] == 'draft';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: MustTheme.lightGreen,
                                child: Text(
                                  timetable['program'].toString().split(' ')[0][0],
                                  style: const TextStyle(
                                    color: MustTheme.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    timetable['program'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  if (isDraft)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.amber[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Draft',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.amber[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Published',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(timetable['name']),
                                  Text(
                                    'Generated on: ${timetable['date']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility),
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ViewTimetableScreen(
                                            programName: timetable['program'],
                                          ),
                                        ),
                                      );
                                    },
                                    tooltip: 'View',
                                  ),
                                  if (isDraft)
                                    IconButton(
                                      icon: const Icon(Icons.publish),
                                      color: Colors.amber[800],
                                      onPressed: () => _publishTimetable(timetable['id']),
                                      tooltip: 'Publish',
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(Icons.download),
                                      color: MustTheme.primaryGreen,
                                      onPressed: () {},
                                      tooltip: 'Download',
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () => _confirmDelete(timetable['id']),
                                    tooltip: 'Delete',
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GenerateTimetableScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Generate New'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: MustTheme.lightGreen,
      checkmarkColor: MustTheme.primaryGreen,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filter;
            _filterTimetables();
          });
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No timetables found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Try a different search term'
                : 'Generate a new timetable to get started',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Generate New Timetable'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GenerateTimetableScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}