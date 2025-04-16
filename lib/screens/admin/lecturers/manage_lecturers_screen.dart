import 'package:flutter/material.dart';
import '../../../models/lecturer.dart';
import '../../../theme/must_theme.dart';

class ManageLecturersScreen extends StatefulWidget {
  const ManageLecturersScreen({super.key});

  @override
  _ManageLecturersScreenState createState() => _ManageLecturersScreenState();
}

class _ManageLecturersScreenState extends State<ManageLecturersScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isAddModalOpen = false;

  // Sample data based on provided university data
  final List<Map<String, dynamic>> lecturers = [
  // First page lecturers
  {
    'id': 1,
    'name': 'W. KARIMI',
    'email': 'wkarimi@must.ac.ke',
    'units': ['SSA 3120'],
    'days': ['Monday', 'Wednesday', 'Friday'],
  },
  {
    'id': 2,
    'name': 'D. KITARIA',
    'email': 'dkitaria@must.ac.ke',
    'units': ['CIT 3150', 'CCS 3251'],
    'days': ['Monday', 'Tuesday', 'Thursday'],
  },
  {
    'id': 3,
    'name': 'S. MAGETO',
    'email': 'smageto@must.ac.ke',
    'units': ['CIT 3154', 'CIT 3153', 'CIT 3157'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
  },
  {
    'id': 4,
    'name': 'A. IRUNGU',
    'email': 'airungu@must.ac.ke',
    'units': ['CIT 3153', 'CCS 3255', 'CDS 3253', 'CDS 3353', 'CDS 3350', 'CDS 3452'],
    'days': ['Monday', 'Wednesday', 'Thursday', 'Friday'],
  },
  {
    'id': 5,
    'name': 'M. ASUNTA',
    'email': 'masunta@must.ac.ke',
    'units': ['CCU 3150', 'CIT 3152', 'CCU 3150'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
  },
  {
    'id': 6,
    'name': 'K. MURUNGI',
    'email': 'kmurungi@must.ac.ke',
    'units': ['SMC 3212'],
    'days': ['Monday', 'Tuesday', 'Wednesday'],
  },
  {
    'id': 7,
    'name': 'DR. J. KITHINJI',
    'email': 'jkithinji@must.ac.ke',
    'units': ['CDS 3253', 'CCF 3350', 'CCF 3450'],
    'days': ['Monday', 'Wednesday'],
  },
  {
    'id': 8,
    'name': 'P. NJUGUNA',
    'email': 'pnjuguna@must.ac.ke',
    'units': ['CDS 3251', 'CCS 3351', 'CDS 3402', 'CIT 3201'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
  },
  {
    'id': 9,
    'name': 'J. MWITI',
    'email': 'jmwiti@must.ac.ke',
    'units': ['CCS 3303', 'CCS 3454', 'CCS 3202', 'CIB 3151'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
  },
  {
    'id': 10,
    'name': 'DR. G. GAKII',
    'email': 'ggakii@must.ac.ke',
    'units': ['SMA 3303', 'SMA 3112', 'CDS 3252'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
  },
  {
    'id': 11,
    'name': 'D. KALUI',
    'email': 'dkalui@must.ac.ke',
    'units': ['CIT 3152', 'CIT 3153'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
  },
  {
    'id': 12,
    'name': 'DR. J MUTEMBEI',
    'email': 'jmutembei@must.ac.ke',
    'units': ['SMA 3301', 'CIT 3350'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
  },
  {
    'id': 13,
    'name': 'C. CHEPKOECH',
    'email': 'chepkoech@must.ac.ke',
    'units': ['SMS 3450'],
    'days': ['Monday', 'Tuesday', 'Wednesday'],
  },
  {
    'id': 14,
    'name': 'A. ORTO',
    'email': 'aorto@must.ac.ke',
    'units': ['CD 3450', 'CCF 3451', 'CDS 3402'],
    'days': ['Monday', 'Tuesday', 'Wednesday'],
  },
  {
    'id': 15,
    'name': 'DR. MWADULO',
    'email': 'mwadulo@must.ac.ke',
    'units': ['CIT 3451', 'CIT 3350', 'CCS 3353'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
  },
  {
    'id': 16,
    'name': 'J. JENU',
    'email': 'jenu@must.ac.ke',
    'units': ['CIT 3350', 'CCS 3451', 'CCS 3355'],
    'days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
  },
  // Add more lecturers from other pages if needed
];

  List<Map<String, dynamic>> filteredLecturers = [];

  @override
  void initState() {
    super.initState();
    filteredLecturers = List.from(lecturers);
    _searchController.addListener(_filterLecturers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLecturers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterLecturers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredLecturers = List.from(lecturers);
      } else {
        filteredLecturers = lecturers
            .where((lecturer) =>
                lecturer['name'].toLowerCase().contains(query) ||
                lecturer['email'].toLowerCase().contains(query) ||
                lecturer['units'].any((unit) => unit.toLowerCase().contains(query)))
            .toList();
      }
    });
  }

  void _deleteLecturer(int id) {
    setState(() {
      lecturers.removeWhere((lecturer) => lecturer['id'] == id);
      _filterLecturers();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lecturer deleted successfully'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $name?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteLecturer(id);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Lecturers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _searchController.clear();
                filteredLecturers = List.from(lecturers);
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAddModalOpen = true;
          });
          _showAddLecturerDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search lecturers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          
          // Lecturers List
          Expanded(
            child: filteredLecturers.isEmpty
                ? const Center(
                    child: Text('No lecturers found.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredLecturers.length,
                    itemBuilder: (context, index) {
                      final lecturer = filteredLecturers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: MustTheme.lightGreen,
                                    radius: 24,
                                    child: Text(
                                      lecturer['name'][0],
                                      style: const TextStyle(
                                        fontSize: 18,
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
                                          lecturer['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          lecturer['email'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${lecturer['units'].length} units assigned',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.blue,
                                    onPressed: () {
                                      _showEditLecturerDialog(context, lecturer);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      _confirmDelete(lecturer['id'], lecturer['name']);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Assigned Units',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(
                                  lecturer['units'].length,
                                  (i) => Chip(
                                    label: Text(lecturer['units'][i]),
                                    backgroundColor: MustTheme.lightGreen,
                                    labelStyle: const TextStyle(
                                        color: MustTheme.primaryGreen),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Preferred Days',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(
                                  lecturer['days'].length,
                                  (i) => Chip(
                                    label: Text(lecturer['days'][i]),
                                    backgroundColor: Colors.blue[50],
                                    labelStyle: TextStyle(color: Colors.blue[700]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddLecturerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final List<String> selectedUnits = [];
    final List<String> selectedDays = [];

    // Sample units from the university data
    final List<String> availableUnits = [
      'CIT 3150', 'CIT 3154', 'CIT 3153', 'CCU 3150', 'CIT 3152',
      'CCS 3255', 'CDS 3253', 'CDS 3251', 'CCS 3252', 'SMC 3212',
      'CCS 3303', 'SMA 3303', 'SSA 3120', 'CIT 3157', 'CDS 3350',
      'CDS 3354', 'SMA 3301', 'CIT 3350', 'CDS 3452', 'CDS 3451'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Lecturer'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Lecturer Name',
                        hintText: 'Enter full name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Assign Units',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableUnits.map((unit) {
                        final isSelected = selectedUnits.contains(unit);
                        return FilterChip(
                          label: Text(unit),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedUnits.add(unit);
                              } else {
                                selectedUnits.remove(unit);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Preferred Days',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((day) {
                        final isSelected = selectedDays.contains(day);
                        return FilterChip(
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isAddModalOpen = false;
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        selectedUnits.isNotEmpty &&
                        selectedDays.isNotEmpty) {
                      setState(() {
                        // Add new lecturer
                        lecturers.add({
                          'id': lecturers.length + 1,
                          'name': nameController.text,
                          'email': emailController.text,
                          'units': selectedUnits,
                          'days': selectedDays,
                        });
                        filteredLecturers = List.from(lecturers);
                      });
                      Navigator.of(context).pop();
                      _isAddModalOpen = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lecturer added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Add Lecturer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditLecturerDialog(BuildContext context, Map<String, dynamic> lecturer) {
    final nameController = TextEditingController(text: lecturer['name']);
    final emailController = TextEditingController(text: lecturer['email']);
    final List<String> selectedUnits = List.from(lecturer['units']);
    final List<String> selectedDays = List.from(lecturer['days']);

    // Sample units from the university data
    final List<String> availableUnits = [
      'CIT 3150', 'CIT 3154', 'CIT 3153', 'CCU 3150', 'CIT 3152',
      'CCS 3255', 'CDS 3253', 'CDS 3251', 'CCS 3252', 'SMC 3212',
      'CCS 3303', 'SMA 3303', 'SSA 3120', 'CIT 3157', 'CDS 3350',
      'CDS 3354', 'SMA 3301', 'CIT 3350', 'CDS 3452', 'CDS 3451'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Lecturer'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Lecturer Name',
                        hintText: 'Enter full name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Assign Units',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableUnits.map((unit) {
                        final isSelected = selectedUnits.contains(unit);
                        return FilterChip(
                          label: Text(unit),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedUnits.add(unit);
                              } else {
                                selectedUnits.remove(unit);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Preferred Days',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((day) {
                        final isSelected = selectedDays.contains(day);
                        return FilterChip(
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        selectedUnits.isNotEmpty &&
                        selectedDays.isNotEmpty) {
                      setState(() {
                        // Update lecturer
                        final index = lecturers.indexWhere((l) => l['id'] == lecturer['id']);
                        if (index != -1) {
                          lecturers[index] = {
                            'id': lecturer['id'],
                            'name': nameController.text,
                            'email': emailController.text,
                            'units': selectedUnits,
                            'days': selectedDays,
                          };
                          _filterLecturers();
                        }
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lecturer updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Update Lecturer'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}