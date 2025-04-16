import 'dart:async';
import 'package:flutter/material.dart';
import '../../../config/app_constants.dart';
import '../../../models/program.dart';
import '../../../models/timetable.dart';
import '../../../services/timetable_generator.dart';
import '../../../theme/must_theme.dart';
import 'view_timetable_screen.dart';

class GenerateTimetableScreen extends StatefulWidget {
  const GenerateTimetableScreen({super.key});

  @override
  _GenerateTimetableScreenState createState() =>
      _GenerateTimetableScreenState();
}

class _GenerateTimetableScreenState extends State<GenerateTimetableScreen> {
  final TimetableGenerator _timetableGenerator = TimetableGenerator();

  bool _isGenerating = false;
  bool _isComplete = false;
  int _currentStep = 0;
  double _progress = 0;
  final List<int> _selectedPrograms = [];
  List<Timetable>? _generatedTimetables;
  List<Map<String, dynamic>>? _conflicts;

  // Sample data for programs - this would come from a database in a real app
  final List<Program> programs = [
    Program(
      id: 1,
      code: 'BCS',
      name: 'Bachelor of Computer Science',
      year: 1,
      semester: 1,
      studentCount: 120,
      units: ['CIT 3150', 'CIT 3154', 'CIT 3153', 'CCU 3150', 'CIT 3152'],
    ),
    Program(
      id: 2,
      code: 'BCS',
      name: 'Bachelor of Computer Science',
      year: 2,
      semester: 1,
      studentCount: 110,
      units: ['CCS 3251', 'CCS 3255', 'CCS 3252', 'CDS 3251', 'CDS 3253'],
    ),
    Program(
      id: 3,
      code: 'BCS',
      name: 'Bachelor of Computer Science',
      year: 3,
      semester: 1,
      studentCount: 95,
      units: ['CIT 4155', 'CIT 4158', 'CIT 4152', 'CIT 4157', 'CIT 4159'],
    ),
    Program(
      id: 4,
      code: 'BCS',
      name: 'Bachelor of Computer Science',
      year: 4,
      semester: 1,
      studentCount: 85,
      units: ['CIT 5150', 'CIT 5153', 'CIT 5155', 'CIT 5158', 'CIT 5159'],
    ),
    Program(
      id: 5,
      code: 'BDS',
      name: 'Bachelor of Data Science',
      year: 1,
      semester: 1,
      studentCount: 80,
      units: ['CDS 3150', 'CDS 3151', 'CDS 3152', 'CCU 3150', 'CIT 3154'],
    ),
    Program(
      id: 6,
      code: 'BDS',
      name: 'Bachelor of Data Science',
      year: 2,
      semester: 1,
      studentCount: 70,
      units: ['CDS 3251', 'CDS 3253', 'CDS 3255', 'CDS 3257', 'CDS 3259'],
    ),
  ];

  final List<Map<String, dynamic>> steps = [
    {
      'name': 'Loading Data',
      'description': 'Fetching all units, lecturers, and venues',
    },
    {
      'name': 'Analyzing Constraints',
      'description': 'Checking lecturer availability and venue capacities',
    },
    {
      'name': 'Generating Timetables',
      'description': 'Creating schedules based on constraints',
    },
    {
      'name': 'Resolving Conflicts',
      'description': 'Optimizing timetables and resolving conflicts',
    },
  ];

  void _toggleProgram(int programId) {
  setState(() {
    if (_selectedPrograms.contains(programId)) {
      _selectedPrograms.remove(programId);
    } else {
      _selectedPrograms.add(programId);
    }
    
    // Reset generation state when programs are modified
    _isGenerating = false;
    _isComplete = false;
    _currentStep = 0;
    _progress = 0;
    _generatedTimetables = null;
    _conflicts = null;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Timetable'),
        actions: [
          if (!_isGenerating && !_isComplete)
            TextButton.icon(
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Generate',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _selectedPrograms.isEmpty ? null : _generateTimetable,
            ),
          if (_isComplete)
            TextButton.icon(
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _resetGenerator,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left panel - Program selection
                SizedBox(
                  width: 300,
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Select Programs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: programs.length,
                            itemBuilder: (context, index) {
                              final program = programs[index];
                              final isSelected =
                                  _selectedPrograms.contains(program.id);

                              return ListTile(
                                selected: isSelected,
                                selectedTileColor: MustTheme.lightGreen,
                                leading: CircleAvatar(
                                  backgroundColor: isSelected
                                      ? MustTheme.primaryGreen
                                      : Colors.grey[200],
                                  child: isSelected
                                      ? const Icon(Icons.check,
                                          color: Colors.white)
                                      : Text(
                                          program.code[0],
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey[700],
                                          ),
                                        ),
                                ),
                                title: Text(
                                  '${program.code} Year ${program.year}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${program.name}, Semester ${program.semester}',
                                ),
                                onTap: () => _toggleProgram(program.id),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right panel - Generation status
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    child: !_isGenerating && !_isComplete
                        ? _buildEmptyState()
                        : _buildGenerationStatus(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'Ready to Generate Timetables',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select programs from the left panel and click Generate',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Generate Timetable'),
            onPressed: _selectedPrograms.isEmpty ? null : _generateTimetable,
          ),
        ],
      ),
    );
  }

  Widget _buildGenerationStatus() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isComplete ? 'Generation Complete' : 'Generation Progress',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress / 100,
                  backgroundColor: Colors.grey[200],
                  color: _isComplete ? Colors.green : Colors.blue,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isGenerating)
                    const Text(
                      'Processing...',
                      style: TextStyle(color: Colors.blue),
                    )
                  else if (_isComplete)
                    const Text(
                      'Complete',
                      style: TextStyle(color: Colors.green),
                    )
                  else
                    const SizedBox(),
                  Text('${_progress.toStringAsFixed(0)}%'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Steps progress
          Card(
            elevation: 0,
            color: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final step = steps[index];
                final isActive = _currentStep == index;
                final isCompleted = _currentStep > index ||
                    (_isComplete && _currentStep == index);

                return ListTile(
                  leading: isCompleted
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : isActive
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.blue,
                              ),
                            )
                          : const Icon(Icons.circle, color: Colors.grey),
                  title: Text(
                    step['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? Colors.green
                          : isActive
                              ? Colors.blue
                              : Colors.grey[700],
                    ),
                  ),
                  subtitle: Text(step['description']),
                  tileColor: isActive ? Colors.blue.withOpacity(0.05) : null,
                );
              },
            ),
          ),

          // Conflicts section (only show if completed)
          if (_isComplete && _conflicts != null && _conflicts!.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Conflicts Detected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _conflicts!.length,
              itemBuilder: (context, index) {
                final conflict = _conflicts![index];
                final isError = conflict['severity'] == 'error';
                final color = isError ? Colors.red : Colors.orange;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isError ? Icons.error : Icons.warning,
                        color: color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          conflict['message'],
                          style: TextStyle(color: color.shade800),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Resolve'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Auto-resolve all conflicts'),
              ),
            ),
          ],

          // Generated timetables (only show if completed)
          if (_isComplete && _generatedTimetables != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Generated Timetables',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _generatedTimetables!.length,
              itemBuilder: (context, index) {
                final timetable = _generatedTimetables![index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      '${timetable.programCode} Year ${timetable.programYear}, Semester ${timetable.programSemester}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(timetable.programName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // Navigate to view timetable screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewTimetableScreen(
                                  programName: timetable.programDisplayCode,
                                ),
                              ),
                            );
                          },
                          child: const Text('View'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('PDF'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

 void _generateTimetable() async {
  if (_selectedPrograms.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppConstants.errorNoPrograms),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  setState(() {
    _isGenerating = true;
    _currentStep = 0;
    _progress = 0;
    _isComplete = false;
    _generatedTimetables = null;
    _conflicts = null;
  });

  _simulateGenerationProgress();
}

void _simulateGenerationProgress() {
  // Set up a timer to simulate the generation process
  const totalSteps = 100;
  const totalDuration = Duration(seconds: 5);
  const stepDuration = Duration(milliseconds: 50);
  final stepIncrement = 1 / (totalDuration.inMilliseconds / stepDuration.inMilliseconds);

  int step = 0;
  Timer.periodic(stepDuration, (timer) {
    if (mounted) {
      setState(() {
        _progress = (step * stepIncrement * 100).clamp(0, 100);

        if (step % 20 == 0 && _currentStep < 3) {
          _currentStep = (_progress / 30).floor().clamp(0, 3);
        }

        step++;

        if (_progress >= 100) {
          timer.cancel();
          _completeGeneration();
        }
      });
    } else {
      timer.cancel();
    }
  });
}  void _completeGeneration() {
    // In a real app, this would process actual generated timetables
    setState(() {
      _isGenerating = false;
      _isComplete = true;
      _currentStep = 3;
      _progress = 100;
      
      // Create sample generated timetables
      _generatedTimetables = [];
      for (int programId in _selectedPrograms) {
        Program program = programs.firstWhere((p) => p.id == programId);
        _generatedTimetables!.add(
          Timetable(
            id: DateTime.now().millisecondsSinceEpoch + programId,
            programCode: program.code,
            programYear: program.year,
            programSemester: program.semester,
            programName: program.name,
            generatedDate: DateTime.now(),
            sessions: [], // In a real app, this would contain actual timetable sessions
          ),
        );
      }
      _conflicts = [
        {
          'type': 'lecturer',
          'message': 'Dr. J. Kithinji has overlapping schedules on Tuesday',
          'severity': 'warning',
        },
        {
          'type': 'venue',
          'message': 'TB 08 is double-booked on Monday 10AM-11AM',
          'severity': 'error',
        },
      ];
    });
  }

  void _resetGenerator() {
    setState(() {
      _isGenerating = false;
      _isComplete = false;
      _currentStep = 0;
      _progress = 0;
      _selectedPrograms.clear();
      _generatedTimetables = null;
      _conflicts = null;
    });
  }
}

