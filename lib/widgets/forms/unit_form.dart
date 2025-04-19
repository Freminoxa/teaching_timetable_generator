import 'package:flutter/material.dart';
import '../../models/unit.dart';

class UnitForm extends StatefulWidget {
  final Unit? unit;
  final Function(Unit) onSave;

  const UnitForm({
    super.key, 
    this.unit, 
    required this.onSave
  });

  @override
  _UnitFormState createState() => _UnitFormState();
}

class _UnitFormState extends State<UnitForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _hoursController;
  late TextEditingController _assignedLecturerController;
  bool _requiresLab = false;
  
  // Sample programs for selection
  final List<String> _availablePrograms = [
    'BCS Y1S1', 'BCS Y2S1', 'BCS Y3S1', 'BCS Y4S1',
    'BDS Y1S1', 'BDS Y2S1', 'BDS Y3S2', 'BDS Y4S1',
    'BBIT Y1S2', 'BBIT Y2S2', 'BBIT Y3S2', 'BBIT Y4S2',
    'BCJ Y1S1', 'BIS Y1S1'
  ];
  
  final List<String> _selectedPrograms = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing unit data or empty
    _codeController = TextEditingController(text: widget.unit?.code ?? '');
    _nameController = TextEditingController(text: widget.unit?.name ?? '');
    _hoursController = TextEditingController(
      text: widget.unit?.hoursPerWeek != null 
        ? widget.unit!.hoursPerWeek.toString() 
        : '3'
    );
    _assignedLecturerController = TextEditingController(
      text: widget.unit?.assignedLecturer ?? ''
    );
    _requiresLab = widget.unit?.requiresLab ?? false;
    
    // Populate selected programs if editing existing unit
    if (widget.unit != null) {
      _selectedPrograms.addAll(widget.unit!.programs ?? []);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _hoursController.dispose();
    _assignedLecturerController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Ensure at least one program is selected
      if (_selectedPrograms.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one program'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create or update unit
      Unit unit = Unit(
        id: widget.unit?.id ?? DateTime.now().millisecondsSinceEpoch,
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        requiresLab: _requiresLab,
        hoursPerWeek: int.parse(_hoursController.text.trim()),
        programs: _selectedPrograms,
        assignedLecturer: _assignedLecturerController.text.trim(),
      );

      // Call the save callback
      widget.onSave(unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.unit == null ? 'Add New Unit' : 'Edit Unit'),
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
                  labelText: 'Unit Code',
                  hintText: 'e.g., CIT 3150',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Unit Name',
                  hintText: 'e.g., Web Development',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _assignedLecturerController,
                decoration: const InputDecoration(
                  labelText: 'Assigned Lecturer',
                  hintText: 'e.g., Dr. John Doe',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(
                  labelText: 'Hours per Week',
                  hintText: 'Number of teaching hours',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hours per week';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _requiresLab,
                    onChanged: (bool? value) {
                      setState(() {
                        _requiresLab = value ?? false;
                      });
                    },
                  ),
                  const Text('This unit requires a lab'),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Assign Programs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availablePrograms.map((program) {
                  final isSelected = _selectedPrograms.contains(program);
                  return FilterChip(
                    label: Text(program),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedPrograms.add(program);
                        } else {
                          _selectedPrograms.remove(program);
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
          child: Text(widget.unit == null ? 'Add Unit' : 'Update Unit'),
        ),
      ],
    );
  }
}