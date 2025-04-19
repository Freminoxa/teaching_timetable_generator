//lib/screens/admin/programs/manage_programs_screen.dart
import 'package:flutter/material.dart';
import '../../../theme/must_theme.dart';
import '../../../models/program.dart';
import '../../../widgets/forms/program_form.dart';

class ManageProgramsScreen extends StatefulWidget {
  const ManageProgramsScreen({super.key});

  @override
  _ManageProgramsScreenState createState() => _ManageProgramsScreenState();
}

class _ManageProgramsScreenState extends State<ManageProgramsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Program> _programs = [];
  List<Program> _filteredPrograms = [];
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  void _loadPrograms() {
    // Initial sample programs based on the timetable data
    setState(() {
  _programs = [
    // Bachelor of Computer Science (BCS) Programs
    Program(
      id: 1,
      code: 'BCS',
      name: 'Bachelor of Computer Science',
      year: 1,
      semester: 1,
      studentCount: 120,
      units: [
        'CIT 3150', 'CIT 3154', 'CIT 3153', 'CCU 3150', 'CIT 3152', 
        'CCF 3100', 'SMA 3112'
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
        'CCS 3251', 'CCS 3255', 'CCS 3252', 'CDS 3251', 'CCS 3250', 
        'CCS 3253', 'CIT 3253'
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
        'CCS 3353', 'CCS 3355', 'CIT 3350', 'CCS 3354', 'CCS 3351', 
        'CIT 3253', 'CCF 3351'
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
        'CIT 3451', 'CCS 3451', 'CCF 3451', 'CDS 3402', 'CIT 3454', 
        'CCF 3456', 'CIT 3350'
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
        'CDS 3253', 'CCS 3255', 'CDS 3251', 'CCS 3250', 'SSA 3120', 
        'SPS 3255', 'CDS 3352'
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
        'CDS 3251', 'CDS 3253', 'CCS 3251', 'CCS 3252', 'CDS 3352', 
        'CDS 3353', 'CIT 3253'
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
        'CDS 3350', 'CDS 3353', 'CDS 3351', 'CDS 3354', 'CDS 3452', 
        'CDS 3451', 'SMA 3301'
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
        'CDS 3400', 'CDS 3402', 'CCS 3454', 'CDS 3451', 'CIT 3350', 
        'SMA 3154', 'SMS 3450'
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
        'CIT 3150', 'CIT 3154', 'CIT 3152', 'BFC 3125', 'SMC 3210', 
        'CIT 3251', 'SPS 3250'
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
        'CIT 3253', 'CIT 3255', 'CCS 3350', 'BFB 3200', 'CIB 3351', 
        'CIT 3358', 'BFB 3252'
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
        'BFC 3358', 'CIT 3451', 'CIT 3454', 'CCS 3481', 'CCF 3450', 
        'BFB 3205', 'SMS 3450'
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
        'CDS 3402', 'CIT 3451', 'CIB 3454', 'BFB 3252', 'CIT 3454', 
        'SMS 3450', 'SMA 3154'
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
        'BCJ 3152', 'BCJ 3153', 'CCU 3102', 'CCU 3451', 'JOO 3456', 
        'COMO 3456', 'COMO 3455'
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
        'CIS 3151', 'CIS 3153', 'CIS 3150', 'CIS 3251', 'CIS 3255', 
        'CIS 3253', 'CIS 3250'
      ],
    ),
  ];

      _filteredPrograms = _programs;
    });
  }

  void _filterPrograms(String query) {
    setState(() {
      _filteredPrograms = _programs.where((program) {
        final matchesQuery = program.name.toLowerCase().contains(query.toLowerCase()) ||
                              program.code.toLowerCase().contains(query.toLowerCase());
        
        if (_currentFilter == 'all') return matchesQuery;
        if (_currentFilter != 'all') {
          return matchesQuery && program.code == _currentFilter;
        }
        
        return matchesQuery;
      }).toList();
    });
  }

  void _showAddProgramDialog() {
    showDialog(
      context: context,
      builder: (context) => ProgramForm(
        onSave: (program) {
          setState(() {
            // Assign a new ID (in a real app, this would be handled by the database)
            program = program.copyWith(id: _programs.length + 1);
            _programs.add(program);
            _filteredPrograms = _programs;
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Program ${program.name} added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _editProgram(Program program) {
    showDialog(
      context: context,
      builder: (context) => ProgramForm(
        program: program,
        onSave: (updatedProgram) {
          setState(() {
            final index = _programs.indexWhere((p) => p.id == updatedProgram.id);
            if (index != -1) {
              _programs[index] = updatedProgram;
              _filteredPrograms = _programs;
            }
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Program ${updatedProgram.name} updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _deleteProgram(Program program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Program'),
        content: Text('Are you sure you want to delete ${program.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _programs.removeWhere((p) => p.id == program.id);
                _filteredPrograms = _programs;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Program ${program.name} deleted successfully'),
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
        title: const Text('Manage Programs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrograms,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProgramDialog,
        tooltip: 'Add New Program',
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
                    hintText: 'Search programs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterPrograms('');
                            },
                          )
                        : null,
                  ),
                  onChanged: _filterPrograms,
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
                      _buildFilterChip('BCS', 'BCS'),
                      const SizedBox(width: 8),
                      _buildFilterChip('BDS', 'BDS'),
                      const SizedBox(width: 8),
                      _buildFilterChip('BBIT', 'BBIT'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Programs List
          Expanded(
            child: _filteredPrograms.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.school,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'No programs found'
                              : 'No programs added yet',
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
                    itemCount: _filteredPrograms.length,
                    itemBuilder: (context, index) {
                      final program = _filteredPrograms[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: MustTheme.lightGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                program.code,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: MustTheme.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            '${program.code} Year ${program.year}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                program.name,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                'Semester ${program.semester} | ${program.studentCount} students',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editProgram(program),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteProgram(program),
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

  // Build filter chip for programs
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
            _filterPrograms(_searchController.text);
          });
        }
      },
    );
  }
}