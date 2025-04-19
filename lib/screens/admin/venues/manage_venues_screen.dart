import 'package:flutter/material.dart';
import '../../../theme/must_theme.dart';
import '../../../models/venue.dart';
import '../../../widgets/forms/venue_form.dart';

class ManageVenuesScreen extends StatefulWidget {
  const ManageVenuesScreen({super.key});

  @override
  _ManageVenuesScreenState createState() => _ManageVenuesScreenState();
}

class _ManageVenuesScreenState extends State<ManageVenuesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Venue> _venues = [];
  List<Venue> _filteredVenues = [];
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  void _loadVenues() {
    // Venues extracted from the timetable document
    setState(() {
      _venues = [
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
      ];
      _filteredVenues = _venues;
    });
  }

  void _filterVenues(String query) {
    setState(() {
      _filteredVenues = _venues.where((venue) {
        final matchesQuery =
            venue.name.toLowerCase().contains(query.toLowerCase()) ||
                venue.code.toLowerCase().contains(query.toLowerCase());

        if (_currentFilter == 'all') return matchesQuery;
        if (_currentFilter == 'labs') return matchesQuery && venue.isLab;
        if (_currentFilter == 'classrooms') return matchesQuery && !venue.isLab;

        return matchesQuery;
      }).toList();
    });
  }

  void _showAddVenueDialog() {
    showDialog(
      context: context,
      builder: (context) => VenueForm(
        onSave: (venue) {
          // Assign a new ID (in a real app, this would be handled by the database)
          venue = venue.copyWith(id: _venues.length + 1);
          setState(() {
            _venues.add(venue);
            _filteredVenues = _venues;
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Venue ${venue.name} added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _editVenue(Venue venue) {
    showDialog(
      context: context,
      builder: (context) => VenueForm(
        venue: venue,
        onSave: (updatedVenue) {
          setState(() {
            final index = _venues.indexWhere((v) => v.id == updatedVenue.id);
            if (index != -1) {
              _venues[index] = updatedVenue;
              _filteredVenues = _venues;
            }
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Venue ${updatedVenue.name} updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _deleteVenue(Venue venue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Venue'),
        content: Text('Are you sure you want to delete ${venue.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _venues.removeWhere((v) => v.id == venue.id);
                _filteredVenues = _venues;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Venue ${venue.name} deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Venues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVenues,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVenueDialog,
        tooltip: 'Add New Venue',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search venues...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterVenues('');
                            },
                          )
                        : null,
                  ),
                  onChanged: _filterVenues,
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text('Show:'),
                      const SizedBox(width: 8),
                      _buildFilterChip('All', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Labs', 'labs'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Classrooms', 'classrooms'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Venues Grid
          Expanded(
            child: _filteredVenues.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.meeting_room_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'No venues found'
                              : 'No venues added yet',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredVenues.length,
                    itemBuilder: (context, index) {
                      final venue = _filteredVenues[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: venue.isLab
                              ? BorderSide(
                                  color: Colors.blue.shade300, width: 2)
                              : BorderSide.none,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Venue header
                            Container(
                              padding: const EdgeInsets.all(12),
                              color: venue.isLab
                                  ? Colors.blue[50]
                                  : Colors.grey[50],
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: venue.isLab
                                          ? Colors.blue[100]
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      venue.isLab
                                          ? Icons.computer
                                          : Icons.meeting_room,
                                      color: venue.isLab
                                          ? Colors.blue[700]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      venue.code,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: venue.isLab
                                            ? Colors.blue[700]
                                            : Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Venue details
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    venue.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Text(
                                  //   venue.building,
                                  //   style: TextStyle(
                                  //     fontSize: 12,
                                  //     color: Colors.grey[600],
                                  //   ),
                                  // ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Capacity: ${venue.capacity}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Actions
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    color: Colors.blue,
                                    onPressed: () => _editVenue(venue),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    color: Colors.red,
                                    onPressed: () => _deleteVenue(venue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Build filter chip for venues
  Widget _buildFilterChip(String label, String filter) {
    final isSelected = _currentFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: MustTheme.lightGreen,
      checkmarkColor: MustTheme.primaryGreen,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentFilter = filter;
            _filterVenues(_searchController.text);
          });
        }
      },
    );
  }
}
