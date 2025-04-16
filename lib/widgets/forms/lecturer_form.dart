import 'package:flutter/material.dart';
import '../../models/lecturer.dart';
import '../../models/unit.dart';
import '../../theme/must_theme.dart';

class LecturerForm extends StatefulWidget {
  final Lecturer? lecturer;
  final Function(Lecturer) onSave;

  const LecturerForm({
    super.key, 
    this.lecturer, 
    required this.onSave
  });

  @override
  _LecturerFormState createState() => _LecturerFormState();
}

class _LecturerFormState extends State<LecturerForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  // Comprehensive units from the timetable
  final List<Unit> _availableUnits = [
    // Computing Units
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
  ];
  
  final List<String> _selectedUnits = [];
  final List<String> _preferredDays = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing lecturer data or empty
    _nameController = TextEditingController(text: widget.lecturer?.name ?? '');
    _emailController = TextEditingController(
      text: widget.lecturer?.email ?? 
           '${_nameController.text.toLowerCase().replaceAll(' ', '.')}@must.ac.ke'
    );
    
    // Populate selected units and days if editing existing lecturer
    if (widget.lecturer != null) {
      _selectedUnits.addAll(widget.lecturer!.units ?? []);
      _preferredDays.addAll(widget.lecturer!.preferredDays ?? []);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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

      // Ensure at least one preferred day is selected
      if (_preferredDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one preferred day'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create or update lecturer
      Lecturer lecturer = Lecturer(
        id: widget.lecturer?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        units: _selectedUnits,
        preferredDays: _preferredDays, preferredTimeSlots: {},
      );

      // Call the save callback
      widget.onSave(lecturer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.lecturer == null ? 'Add New Lecturer' : 'Edit Lecturer'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g., Dr. J. Kithinji',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lecturer name';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Automatically generate email if not manually edited
                  if (!_emailController.text.contains('@') || 
                      _emailController.text.isEmpty) {
                    _emailController.text = 
                        value.toLowerCase().replaceAll(' ', '.').toLowerCase() + '@must.ac.ke';
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'e.g., j.kithinji@must.ac.ke',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  // Basic email validation
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
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
              const SizedBox(height: 16),
              const Text(
                'Preferred Teaching Days',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                    .map((day) {
                  final isSelected = _preferredDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _preferredDays.add(day);
                        } else {
                          _preferredDays.remove(day);
                        }
                      });
                    },
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
          child: Text(widget.lecturer == null ? 'Add Lecturer' : 'Update Lecturer'),
        ),
      ],
    );
  }
}