import 'package:flutter/material.dart';
import '../../../theme/must_theme.dart';
import '../../../models/unit.dart';
import '../../../widgets/forms/unit_form.dart';

class ManageUnitsScreen extends StatefulWidget {
  const ManageUnitsScreen({super.key});

  @override
  _ManageUnitsScreenState createState() => _ManageUnitsScreenState();
}

class _ManageUnitsScreenState extends State<ManageUnitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Unit> _units = [];
  List<Unit> _filteredUnits = [];
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  void _loadUnits() {
    // TODO: Implement actual unit loading from database or service
   setState(() {
  _units = [
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
  ];

      _filteredUnits = _units;
    });
  }

  void _filterUnits(String query) {
    setState(() {
      _filteredUnits = _units.where((unit) {
        final matchesQuery = unit.name.toLowerCase().contains(query.toLowerCase()) ||
                              unit.code.toLowerCase().contains(query.toLowerCase());
        
        if (_currentFilter == 'all') return matchesQuery;
        if (_currentFilter == 'labs') return matchesQuery && unit.requiresLab;
        if (_currentFilter == 'regular') return matchesQuery && !unit.requiresLab;
        
        return matchesQuery;
      }).toList();
    });
  }

  void _showAddUnitDialog() {
    showDialog(
      context: context,
      builder: (context) => UnitForm(
        onSave: (unit) {
          // TODO: Implement save logic
          setState(() {
            _units.add(unit);
            _filteredUnits = _units;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _editUnit(Unit unit) {
    showDialog(
      context: context,
      builder: (context) => UnitForm(
        unit: unit,
        onSave: (updatedUnit) {
          // TODO: Implement update logic
          setState(() {
            final index = _units.indexWhere((u) => u.id == updatedUnit.id);
            if (index != -1) {
              _units[index] = updatedUnit;
              _filteredUnits = _units;
            }
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteUnit(Unit unit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Unit'),
        content: Text('Are you sure you want to delete ${unit.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete logic
              setState(() {
                _units.removeWhere((u) => u.id == unit.id);
                _filteredUnits = _units;
              });
              Navigator.of(context).pop();
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
        title: const Text('Manage Units'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUnits,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUnitDialog,
        tooltip: 'Add New Unit',
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
                    hintText: 'Search units...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterUnits('');
                            },
                          )
                        : null,
                  ),
                  onChanged: _filterUnits,
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
                      _buildFilterChip('Lab Units', 'labs'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Regular Units', 'regular'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Units List
          Expanded(
            child: _filteredUnits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.work_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'No units found'
                              : 'No units added yet',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredUnits.length,
                    itemBuilder: (context, index) {
                      final unit = _filteredUnits[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: unit.requiresLab
                                  ? Colors.blue[50]
                                  : MustTheme.lightGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              unit.requiresLab
                                  ? Icons.computer
                                  : Icons.book,
                              color: unit.requiresLab
                                  ? Colors.blue
                                  : MustTheme.primaryGreen,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                unit.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (unit.requiresLab)
                                Chip(
                                  label: const Text('Lab'),
                                  backgroundColor: Colors.blue[50],
                                  labelStyle: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(unit.name),
                              Text(
                                'Lecturer: ${unit.assignedLecturer ?? 'Unassigned'}',
                                style: TextStyle(
                                  color: unit.assignedLecturer == null 
                                      ? Colors.red 
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${unit.hoursPerWeek} hrs/week'),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editUnit(unit),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteUnit(unit),
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
    );
  }

  // Build filter chip for units
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
            _filterUnits(_searchController.text);
          });
        }
      },
    );
  }
}