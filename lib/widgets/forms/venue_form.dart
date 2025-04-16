import 'package:flutter/material.dart';
import '../../models/venue.dart';
import '../../theme/must_theme.dart';

class VenueForm extends StatefulWidget {
  final Venue? venue;
  final Function(Venue) onSave;

  const VenueForm({
    super.key, 
    this.venue, 
    required this.onSave
  });

  @override
  _VenueFormState createState() => _VenueFormState();
}

class _VenueFormState extends State<VenueForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _capacityController;
  late TextEditingController _buildingController;
  bool _isLab = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing venue data or empty
    _codeController = TextEditingController(text: widget.venue?.code ?? '');
    _nameController = TextEditingController(text: widget.venue?.name ?? '');
    _capacityController = TextEditingController(
      text: widget.venue?.capacity != null 
        ? widget.venue!.capacity.toString() 
        : ''
    );
    // _buildingController = TextEditingController(text: widget.venue?.building ?? '');
    _isLab = widget.venue?.isLab ?? false;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _capacityController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Create or update venue
      Venue venue = Venue(
        id: widget.venue?.id ?? DateTime.now().millisecondsSinceEpoch,
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        capacity: int.parse(_capacityController.text.trim()),
        isLab: _isLab,
         availability: {},
      );

      // Call the save callback
      widget.onSave(venue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.venue == null ? 'Add New Venue' : 'Edit Venue'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Venue Code',
                  hintText: 'e.g., TB 08',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a venue code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Venue Name',
                  hintText: 'e.g., Teaching Block 8',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a venue name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _buildingController,
                decoration: const InputDecoration(
                  labelText: 'Building',
                  hintText: 'e.g., Main Teaching Block',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the building name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  hintText: 'Number of students',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter venue capacity';
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
                    value: _isLab,
                    onChanged: (bool? value) {
                      setState(() {
                        _isLab = value ?? false;
                      });
                    },
                  ),
                  const Text('This is a computer lab'),
                ],
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
          child: Text(widget.venue == null ? 'Add Venue' : 'Update Venue'),
        ),
      ],
    );
  }
}