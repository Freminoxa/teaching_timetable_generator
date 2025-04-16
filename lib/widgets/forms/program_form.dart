import 'package:flutter/material.dart';
import '../../models/program.dart';
import '../../models/unit.dart';
import '../../theme/must_theme.dart';

class ProgramForm extends StatefulWidget {
  final Program? program;
  final Function(Program) onSave;

  const ProgramForm({
    super.key, 
    this.program, 
    required this.onSave
  });

  @override
  _ProgramFormState createState() => _ProgramFormState();
}

class _ProgramFormState extends State<ProgramForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _studentCountController;
  
  int _selectedYear = 1;
  int _selectedSemester = 1;
  
  // Sample units for selection (would typically come from a database)
  final List<Unit> _availableUnits = [
     Unit(
      id: 1,
      code: 'CIT 3150', 
      name: 'Web Development Technologies', 
      requiresLab: true,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 2,
      code: 'CIT 3154', 
      name: 'Advanced Database Systems', 
      requiresLab: true,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 3,
      code: 'CIT 3153', 
      name: 'Object-Oriented Programming Concepts', 
      requiresLab: true,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 4,
      code: 'CIT 3152', 
      name: 'Operating Systems Architecture', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 5,
      code: 'CIT 3157', 
      name: 'Advanced Networking', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    
    // Computer Science Units
    Unit(
      id: 6,
      code: 'CCS 3251', 
      name: 'Computer Networks Design', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 7,
      code: 'CCS 3255', 
      name: 'Data Communication Protocols', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 8,
      code: 'CCS 3252', 
      name: 'Network Security Fundamentals', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 9,
      code: 'CCS 3303', 
      name: 'Advanced Network Management', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    
    // Data Science Units
    Unit(
      id: 10,
      code: 'CDS 3253', 
      name: 'Advanced Data Analysis Techniques', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 11,
      code: 'CDS 3251', 
      name: 'Statistical Methods and Modeling', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 12,
      code: 'CDS 3350', 
      name: 'Data Mining and Visualization', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    
    // Communication and Other Units
    Unit(
      id: 13,
      code: 'CCU 3150', 
      name: 'Professional Communication Skills', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 14,
      code: 'SMC 3212', 
      name: 'Strategic Management', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 15,
      code: 'SSA 3120', 
      name: 'System Analysis and Design', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    Unit(
      id: 16,
      code: 'SMA 3303', 
      name: 'Advanced Mathematical Methods', 
      requiresLab: false,
       hoursPerWeek: 3,
       programs: []
    ),
    // Add more sample units from the timetable
  ];
  
  final List<String> _selectedUnits = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing program data or empty
    _codeController;
    _nameController = TextEditingController(text: widget.program?.name ?? '');
    _studentCountController = TextEditingController(
      text: widget.program?.studentCount != null 
        ? widget.program!.studentCount.toString() 
        : ''
    );
    
    // Populate selected units if editing existing program
    if (widget.program != null) {
      _selectedUnits.addAll(widget.program!.units ?? []);
      _selectedYear = widget.program!.year;
      _selectedSemester = widget.program!.semester;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _studentCountController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Ensure at least one unit is selected
      if (_selectedUnits.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one unit'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create or update program
      Program program = Program(
        id: widget.program?.id ?? DateTime.now().millisecondsSinceEpoch,
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        year: _selectedYear,
        semester: _selectedSemester,
        studentCount: int.parse(_studentCountController.text.trim()),
        units: _selectedUnits,
      );

      // Call the save callback
      widget.onSave(program);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.program == null ? 'Add New Program' : 'Edit Program'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Program Code',
                  hintText: 'e.g., BCS, BDS, BBIT',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a program code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Program Name',
                  hintText: 'e.g., Bachelor of Computer Science',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a program name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      value: _selectedYear,
                      items: List.generate(4, (index) => index + 1)
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text('Year $year'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedYear = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Semester',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      value: _selectedSemester,
                      items: [1, 2]
                          .map((semester) => DropdownMenuItem(
                                value: semester,
                                child: Text('Semester $semester'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSemester = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _studentCountController,
                decoration: const InputDecoration(
                  labelText: 'Number of Students',
                  hintText: 'Total students in the program',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of students';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Assign Units',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableUnits.map((unit) {
                  final isSelected = _selectedUnits.contains(unit.code);
                  return FilterChip(
                    label: Text('${unit.code}: ${unit.name}'),
                    selected: isSelected,
                    selectedColor: unit.requiresLab 
                        ? Colors.blue[50] 
                        : MustTheme.lightGreen,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedUnits.add(unit.code);
                        } else {
                          _selectedUnits.remove(unit.code);
                        }
                      });
                    },
                    avatar: unit.requiresLab 
                        ? Icon(Icons.computer, 
                            size: 20, 
                            color: Colors.blue[700]) 
                        : null,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: Text(widget.program == null ? 'Add Program' : 'Update Program'),
        ),
      ],
    );
  }
}