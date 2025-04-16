import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUST Timetable Generator',
      debugShowCheckedModeBanner: false,
      theme: MustTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}

// THEME
class MustTheme {
  // Meru University of Science and Technology colors
  static const Color primaryGreen = Color(0xFF007A33);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color white = Colors.white;
  static const Color textColor = Color(0xFF333333);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryGreen,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

// CONSTANTS
class AppConstants {
  static const String appName = 'MUST Timetable Generator';
  static const String currentSession = 'January-May 2025';

  static const List<String> timeSlots = [
    '7AM-8AM',
    '8AM-9AM',
    '9AM-10AM',
    '10AM-11AM',
    '11AM-12PM',
    '12PM-1PM',
    '1PM-2PM',
    '2PM-3PM',
    '3PM-4PM',
    '4PM-5PM',
    '5PM-6PM',
    '6PM-7PM',
    '7PM-8PM'
  ];

  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
}

// LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Changed from final to mutable
  String? _errorMessage;
  bool _obscurePassword = true;

  // Email validation regex
  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  void _validateAndSubmit() {
    // Remove any previous error message
    setState(() {
      _errorMessage = null;
    });

    // Check if form is valid
    if (_formKey.currentState!.validate()) {
      // Set loading state
      setState(() {
        _isLoading = true;
      });

      // Simulate login process
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Email validation specific check
        if (!_emailRegex.hasMatch(_emailController.text.trim())) {
          _showErrorSnackBar('Please enter a valid email address');
          return;
        }

        // Check for empty fields
        if (_emailController.text.trim().isEmpty) {
          _showErrorSnackBar('Please enter your email');
          return;
        }

        if (_passwordController.text.isEmpty) {
          _showErrorSnackBar('Please enter your password');
          return;
        }

        // Specific validation for MUST email domain
        if (!_emailController.text.trim().toLowerCase().endsWith('@must.ac.ke')) {
          _showErrorSnackBar('Only MUST email addresses are allowed');
          return;
        }

        // If all validations pass, navigate to dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AdminDashboard()),
        );
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and University Name
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/image.png',
                      width: 100,
                      height: 100,
                      // Use a placeholder color if you don't have the logo
                      color: MustTheme.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'MERU UNIVERSITY OF SCIENCE AND TECHNOLOGY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MustTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'School of Computing and Informatics',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Timetable Generator',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Login Form
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!_emailRegex.hasMatch(value.trim())) {
                                return 'Enter a valid email address';
                              }
                              if (!value.trim().toLowerCase().endsWith('@must.ac.ke')) {
                                return 'Only MUST email addresses are allowed';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red.shade700, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.login),
                            label: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text('Sign In'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: _isLoading
                                ? null
                                : _validateAndSubmit,
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                // Add forgot password functionality
                                _showErrorSnackBar('Forgot Password feature coming soon');
                              },
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  '© 2025 Meru University of Science and Technology',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ADMIN DASHBOARD
class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Lecturers',
      'icon': Icons.person,
      'count': 32,
      'screen': const ManageLecturersScreen(),
    },
    {
      'title': 'Units',
      'icon': Icons.book,
      'count': 56,
      'screen': const ManageUnitsScreen(),
    },
    {
      'title': 'Venues',
      'icon': Icons.meeting_room,
      'count': 24,
      'screen': const ManageVenuesScreen(),
    },
    {
      'title': 'Programs',
      'icon': Icons.school,
      'count': 8,
      'screen': const ManageProgramsScreen(),
    },
    {
      'title': 'Generate Timetable',
      'icon': Icons.calendar_today,
      'count': null,
      'screen': const GenerateTimetableScreen(),
    },
    {
      'title': 'View Timetables',
      'icon': Icons.schedule,
      'count': 6,
      'screen': const ViewTimetablesScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MustTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            // Stats Cards
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatCard(
                    context,
                    title: 'Current Session',
                    value: 'January-May 2025',
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    title: 'Departments',
                    value: 'Computer Science, IT',
                    icon: Icons.business,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    title: 'Generated Timetables',
                    value: '6 Programs',
                    icon: Icons.schedule,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Timetable Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MustTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildMenuCard(
                    context,
                    title: item['title'],
                    icon: item['icon'],
                    count: item['count'],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => item['screen']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    int? count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: MustTheme.primaryGreen,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (count != null) ...[
                const SizedBox(height: 4),
                Text(
                  '$count items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// MANAGE LECTURERS SCREEN
class ManageLecturersScreen extends StatefulWidget {
  const ManageLecturersScreen({super.key});

  @override
  _ManageLecturersScreenState createState() => _ManageLecturersScreenState();
}

class _ManageLecturersScreenState extends State<ManageLecturersScreen> {
  final TextEditingController _searchController = TextEditingController();
   bool _isAddModalOpen = false;

  // Sample data
  final List<Map<String, dynamic>> lecturers = [
    {
      'id': 1,
      'name': 'W. KARIMI',
      'units': ['SSA 3120'],
      'days': ['Monday', 'Wednesday', 'Friday'],
    },
    {
      'id': 2,
      'name': 'D. KITARIA',
      'units': ['CIT 3150', 'CCS 3251'],
      'days': ['Monday', 'Tuesday', 'Thursday'],
    },
    {
      'id': 3,
      'name': 'S. MAGETO',
      'units': ['CIT 3154', 'CIT 3157'],
      'days': ['Tuesday', 'Wednesday', 'Friday'],
    },
    {
      'id': 4,
      'name': 'A. IRUNGU',
      'units': ['CIT 3153', 'CCS 3255', 'CDS 3353'],
      'days': ['Monday', 'Wednesday', 'Thursday'],
    },
    {
      'id': 5,
      'name': 'M. ASUNTA',
      'units': ['CCU 3150'],
      'days': ['Tuesday', 'Wednesday', 'Friday'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Lecturers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: lecturers.length,
              itemBuilder: (context, index) {
                final lecturer = lecturers[index];
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
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                
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
    final List<String> selectedUnits = [];
    final List<String> selectedDays = [];

    // Sample units
    final List<String> availableUnits = [
      'CIT 3150',
      'CIT 3154',
      'CIT 3153',
      'CCU 3150',
      'CIT 3152',
      'CCS 3255',
      'CDS 3253',
      'CDS 3251',
      'CCS 3252'
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
                      children: AppConstants.daysOfWeek.map((day) {
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
                        selectedUnits.isNotEmpty &&
                        selectedDays.isNotEmpty) {
                      // Add new lecturer
                      // This is just UI demo - no actual implementation
                      Navigator.of(context).pop();
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
}

// MANAGE UNITS SCREEN
class ManageUnitsScreen extends StatefulWidget {
  const ManageUnitsScreen({super.key});

  @override
  _ManageUnitsScreenState createState() => _ManageUnitsScreenState();
}

class _ManageUnitsScreenState extends State<ManageUnitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'all';

  // Sample data
  final List<Map<String, dynamic>> units = [
    {
      'id': 1,
      'code': 'CIT 3150',
      'name': 'Web Development',
      'requiresLab': true,
      'hoursPerWeek': 3,
      'programs': ['BCS Y1S1', 'BBIT Y1S2'],
    },
    {
      'id': 2,
      'code': 'CIT 3154',
      'name': 'Database Systems',
      'requiresLab': true,
      'hoursPerWeek': 3,
      'programs': ['BCS Y1S1', 'BBIT Y1S2'],
    },
    {
      'id': 3,
      'code': 'CIT 3153',
      'name': 'Object-Oriented Programming',
      'requiresLab': true,
      'hoursPerWeek': 3,
      'programs': ['BCS Y1S1'],
    },
    {
      'id': 4,
      'code': 'CCU 3150',
      'name': 'Communication Skills',
      'requiresLab': false,
      'hoursPerWeek': 3,
      'programs': ['BCS Y1S1', 'BDS Y1S1'],
    },
    {
      'id': 5,
      'code': 'CIT 3152',
      'name': 'Operating Systems',
      'requiresLab': false,
      'hoursPerWeek': 3,
      'programs': ['BCS Y1S1'],
    },
  ];

  List<Map<String, dynamic>> get filteredUnits {
    if (_currentFilter == 'all') {
      return units;
    } else if (_currentFilter == 'labs') {
      return units.where((unit) => unit['requiresLab']).toList();
    } else {
      return units.where((unit) => !unit['requiresLab']).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Units'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add unit modal
          _showAddUnitDialog(context);
        },
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
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
              ],
            ),
          ),
          // Units List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredUnits.length,
              itemBuilder: (context, index) {
                final unit = filteredUnits[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: unit['requiresLab']
                                    ? Colors.blue[50]
                                    : MustTheme.lightGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                unit['requiresLab']
                                    ? Icons.computer
                                    : Icons.book,
                                color: unit['requiresLab']
                                    ? Colors.blue
                                    : MustTheme.primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        unit['code'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (unit['requiresLab'])
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Lab',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    unit['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${unit['hoursPerWeek']} hrs/week',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Programs',
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
                            unit['programs'].length,
                            (i) => Chip(
                              label: Text(unit['programs'][i]),
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(color: Colors.grey[800]),
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
          });
        }
      },
    );
  }

  void _showAddUnitDialog(BuildContext context) {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final hoursController = TextEditingController(text: '3');
    bool requiresLab = false;
    final List<String> selectedPrograms = [];

    // Sample programs
    final List<String> availablePrograms = [
      'BCS Y1S1',
      'BCS Y2S1',
      'BCS Y3S1',
      'BCS Y4S1',
      'BDS Y1S1',
      'BDS Y2S1',
      'BDS Y3S2',
      'BDS Y4S1',
      'BBIT Y1S2',
      'BBIT Y2S2',
      'BBIT Y3S2',
      'BBIT Y4S2'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Unit'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Code',
                        hintText: 'e.g., CIT 3150',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Name',
                        hintText: 'e.g., Web Development',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Hours Per Week',
                        hintText: 'e.g., 3',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: requiresLab,
                          onChanged: (value) {
                            setState(() {
                              requiresLab = value ?? false;
                            });
                          },
                        ),
                        const Text('Requires Lab'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Assign Programs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availablePrograms.map((program) {
                        final isSelected = selectedPrograms.contains(program);
                        return FilterChip(
                          label: Text(program),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedPrograms.add(program);
                              } else {
                                selectedPrograms.remove(program);
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
                    if (codeController.text.isNotEmpty &&
                        nameController.text.isNotEmpty &&
                        hoursController.text.isNotEmpty &&
                        selectedPrograms.isNotEmpty) {
                      // Add new unit
                      // This is just UI demo - no actual implementation
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Unit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// MANAGE VENUES SCREEN
class ManageVenuesScreen extends StatefulWidget {
  const ManageVenuesScreen({super.key});

  @override
  _ManageVenuesScreenState createState() => _ManageVenuesScreenState();
}

class _ManageVenuesScreenState extends State<ManageVenuesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'all';

  // Sample data
  final List<Map<String, dynamic>> venues = [
    {
      'id': 1,
      'code': 'TB 08',
      'name': 'Teaching Block 8',
      'capacity': 60,
      'isLab': false,
    },
    {
      'id': 2,
      'code': 'TB 05',
      'name': 'Teaching Block 5',
      'capacity': 45,
      'isLab': false,
    },
    {
      'id': 3,
      'code': 'ECB 05',
      'name': 'Engineering Block 5',
      'capacity': 40,
      'isLab': true,
    },
    {
      'id': 4,
      'code': 'TB 16',
      'name': 'Teaching Block 16',
      'capacity': 55,
      'isLab': false,
    },
    {
      'id': 5,
      'code': 'TB 06',
      'name': 'Teaching Block 6',
      'capacity': 50,
      'isLab': false,
    },
    {
      'id': 6,
      'code': 'TB 11',
      'name': 'Teaching Block 11',
      'capacity': 45,
      'isLab': true,
    },
  ];

  List<Map<String, dynamic>> get filteredVenues {
    if (_currentFilter == 'all') {
      return venues;
    } else if (_currentFilter == 'labs') {
      return venues.where((venue) => venue['isLab']).toList();
    } else {
      return venues.where((venue) => !venue['isLab']).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Venues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add venue modal
          _showAddVenueDialog(context);
        },
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
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
              ],
            ),
          ),
          // Venues Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredVenues.length,
              itemBuilder: (context, index) {
                final venue = filteredVenues[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: venue['isLab']
                        ? BorderSide(color: Colors.blue.shade300, width: 2)
                        : BorderSide.none,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Venue header
                      Container(
                        padding: const EdgeInsets.all(12),
                        color:
                            venue['isLab'] ? Colors.blue[50] : Colors.grey[50],
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: venue['isLab']
                                    ? Colors.blue[100]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                venue['isLab']
                                    ? Icons.computer
                                    : Icons.meeting_room,
                                color: venue['isLab']
                                    ? Colors.blue[700]
                                    : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                venue['code'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: venue['isLab']
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
                              venue['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.people,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Capacity: ${venue['capacity']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (venue['isLab'])
                              Chip(
                                label: const Text('Computer Lab'),
                                labelStyle: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 12,
                                ),
                                backgroundColor: Colors.blue[50],
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
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
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: Colors.red,
                              onPressed: () {},
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
          });
        }
      },
    );
  }

  void _showAddVenueDialog(BuildContext context) {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '40');
    bool isLab = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Venue'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: 'Venue Code',
                        hintText: 'e.g., TB 08',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Venue Name',
                        hintText: 'e.g., Teaching Block 8',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Capacity',
                        hintText: 'Enter room capacity',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isLab,
                          onChanged: (value) {
                            setState(() {
                              isLab = value ?? false;
                            });
                          },
                        ),
                        const Text('This is a computer lab'),
                      ],
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
                    if (codeController.text.isNotEmpty &&
                        nameController.text.isNotEmpty &&
                        capacityController.text.isNotEmpty) {
                      // Add new venue
                      // This is just UI demo - no actual implementation
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Venue'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// MANAGE PROGRAMS SCREEN
class ManageProgramsScreen extends StatefulWidget {
  const ManageProgramsScreen({super.key});

  @override
  _ManageProgramsScreenState createState() => _ManageProgramsScreenState();
}

class _ManageProgramsScreenState extends State<ManageProgramsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'all';

  // Sample data
  final List<Map<String, dynamic>> programs = [
    {
      'id': 1,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 1,
      'semester': 1,
      'students': 70,
      'units': 6,
    },
    {
      'id': 2,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 2,
      'semester': 1,
      'students': 80,
      'units': 6,
    },
    {
      'id': 3,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 3,
      'semester': 1,
      'students': 75,
      'units': 6,
    },
    {
      'id': 4,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 4,
      'semester': 1,
      'students': 85,
      'units': 6,
    },
    {
      'id': 5,
      'code': 'BDS',
      'name': 'Bachelor of Data Science',
      'year': 1,
      'semester': 1,
      'students': 80,
      'units': 6,
    },
    {
      'id': 6,
      'code': 'BDS',
      'name': 'Bachelor of Data Science',
      'year': 2,
      'semester': 1,
      'students': 70,
      'units': 6,
    },
    {
      'id': 7,
      'code': 'BBIT',
      'name': 'Bachelor of Business Information Technology',
      'year': 1,
      'semester': 2,
      'students': 60,
      'units': 6,
    },
    {
      'id': 8,
      'code': 'BBIT',
      'name': 'Bachelor of Business Information Technology',
      'year': 2,
      'semester': 2,
      'students': 55,
      'units': 6,
    },
  ];

  List<Map<String, dynamic>> get filteredPrograms {
    return _currentFilter == 'all'
        ? programs
        : programs
            .where((program) => program['code'] == _currentFilter)
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Programs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add program modal
          _showAddProgramDialog(context);
        },
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: Colors.white,
                  ),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredPrograms.length,
              itemBuilder: (context, index) {
                final program = filteredPrograms[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: MustTheme.lightGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                program['code'],
                                style: const TextStyle(
                                  fontSize: 16,
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
                                    program['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Year ${program['year']}, Semester ${program['semester']}',
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
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildInfoItem(
                              icon: Icons.people,
                              label: 'Students',
                              value: program['students'].toString(),
                            ),
                            const SizedBox(width: 24),
                            _buildInfoItem(
                              icon: Icons.book,
                              label: 'Units',
                              value: program['units'].toString(),
                            ),
                          ],
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
          });
        }
      },
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showAddProgramDialog(BuildContext context) {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final yearController = TextEditingController();
    final semesterController = TextEditingController();
    final studentsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Program'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Program Code',
                    hintText: 'e.g., BCS',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Program Name',
                    hintText: 'e.g., Bachelor of Computer Science',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          hintText: '1-4',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: semesterController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Semester',
                          hintText: '1-2',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: studentsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of Students',
                    hintText: 'Enter total students',
                  ),
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
                if (codeController.text.isNotEmpty &&
                    nameController.text.isNotEmpty &&
                    yearController.text.isNotEmpty &&
                    semesterController.text.isNotEmpty) {
                  // Add new program
                  // This is just UI demo - no actual implementation
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Program'),
            ),
          ],
        );
      },
    );
  }
}

// GENERATE TIMETABLE SCREEN
class GenerateTimetableScreen extends StatefulWidget {
  const GenerateTimetableScreen({super.key});

  @override
  _GenerateTimetableScreenState createState() =>
      _GenerateTimetableScreenState();
}

class _GenerateTimetableScreenState extends State<GenerateTimetableScreen> {
  bool _isGenerating = false;
  bool _isComplete = false;
  int _currentStep = 0;
  double _progress = 0;
  final List<int> _selectedPrograms = [];

  final List<Map<String, dynamic>> programs = [
    {
      'id': 1,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 1,
      'semester': 1,
    },
    {
      'id': 2,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 2,
      'semester': 1,
    },
    {
      'id': 3,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 3,
      'semester': 1,
    },
    {
      'id': 4,
      'code': 'BCS',
      'name': 'Bachelor of Computer Science',
      'year': 4,
      'semester': 1,
    },
    {
      'id': 5,
      'code': 'BDS',
      'name': 'Bachelor of Data Science',
      'year': 1,
      'semester': 1,
    },
    {
      'id': 6,
      'code': 'BDS',
      'name': 'Bachelor of Data Science',
      'year': 2,
      'semester': 1,
    },
    {
      'id': 7,
      'code': 'BDS',
      'name': 'Bachelor of Data Science',
      'year': 3,
      'semester': 1,
    },
    {
      'id': 8,
      'code': 'BDS',
      'name': 'Bachelor of Data Science',
      'year': 4,
      'semester': 1,
    },
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

  final List<Map<String, dynamic>> conflicts = [
    {
      'type': 'lecturer',
      'message': 'no lecturer conflict detected',
      'severity': 'status',
    },
    {
      'type': 'venue',
      'message': 'TB 08 is double-booked on Monday 10AM-11AM',
      'severity': 'error',
    },
  ];

  void _toggleProgram(int programId) {
    setState(() {
      if (_selectedPrograms.contains(programId)) {
        _selectedPrograms.remove(programId);
      } else {
        _selectedPrograms.add(programId);
      }
    });
  }

  void _generateTimetable() {
    if (_selectedPrograms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one program')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _currentStep = 0;
      _progress = 0;
      _isComplete = false;
    });

    // Simulate generation process
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isComplete = true;
          _currentStep = 3;
          _progress = 100;
        });
      }
    });

    // Update progress animation
    const totalSteps = 100;
    const totalDuration = Duration(seconds: 5);
    const stepDuration = Duration(milliseconds: 50);
    final stepIncrement =
        1 / (totalDuration.inMilliseconds / stepDuration.inMilliseconds);

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
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resetGenerator() {
    setState(() {
      _isGenerating = false;
      _isComplete = false;
      _currentStep = 0;
      _progress = 0;
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
                                  _selectedPrograms.contains(program['id']);

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
                                          program['code'][0],
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey[700],
                                          ),
                                        ),
                                ),
                                title: Text(
                                  '${program['code']} Year ${program['year']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${program['name']}, Semester ${program['semester']}',
                                ),
                                onTap: () => _toggleProgram(program['id']),
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
          if (_isComplete && conflicts.isNotEmpty) ...[
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
              itemCount: conflicts.length,
              itemBuilder: (context, index) {
                final conflict = conflicts[index];
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
          if (_isComplete) ...[
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
              itemCount: _selectedPrograms.length,
              itemBuilder: (context, index) {
                final programId = _selectedPrograms[index];
                final program =
                    programs.firstWhere((p) => p['id'] == programId);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      '${program['code']} Year ${program['year']}, Semester ${program['semester']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(program['name']),
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
                                  programName:
                                      '${program['code']} Y${program['year']}S${program['semester']}',
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
}

// VIEW TIMETABLES SCREEN
class ViewTimetablesScreen extends StatelessWidget {
  const ViewTimetablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<Map<String, dynamic>> timetables = [
      {
        'id': 1,
        'program': 'BCS Y1S1',
        'name': 'Bachelor of Computer Science',
        'year': 1,
        'semester': 1,
        'date': '15 Jan 2025',
      },
      {
        'id': 2,
        'program': 'BCS Y2S1',
        'name': 'Bachelor of Computer Science',
        'year': 2,
        'semester': 1,
        'date': '15 Jan 2025',
      },
      {
        'id': 3,
        'program': 'BCS Y3S1',
        'name': 'Bachelor of Computer Science',
        'year': 3,
        'semester': 1,
        'date': '15 Jan 2025',
      },
      {
        'id': 4,
        'program': 'BCS Y4S1',
        'name': 'Bachelor of Computer Science',
        'year': 4,
        'semester': 1,
        'date': '15 Jan 2025',
      },
      {
        'id': 5,
        'program': 'BDS Y1S1',
        'name': 'Bachelor of Data Science',
        'year': 1,
        'semester': 1,
        'date': '15 Jan 2025',
      },
      {
        'id': 6,
        'program': 'BDS Y2S1',
        'name': 'Bachelor of Data Science',
        'year': 2,
        'semester': 1,
        'date': '15 Jan 2025',
      },
       {
        'id': 7,
        'program': 'BDS Y3S1',
        'name': 'Bachelor of Data Science',
        'year': 3,
        'semester': 1,
        'date': '15 Jan 2025',
      },
       {
        'id': 7,
        'program': 'BDS Y4S1',
        'name': 'Bachelor of Data Science',
        'year': 4,
        'semester': 1,
        'date': '15 Jan 2025',
      },
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Text('View Timetables'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search timetables...',
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

          // Timetables List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: timetables.length,
              itemBuilder: (context, index) {
                final timetable = timetables[index];

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
                    title: Text(
                      timetable['program'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                        ),
                        IconButton(
                          icon: const Icon(Icons.download),
                          color: MustTheme.primaryGreen,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {},
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
}

// VIEW TIMETABLE SCREEN (DETAILED VIEW)
class ViewTimetableScreen extends StatelessWidget {
  final String programName;

  const ViewTimetableScreen({
    super.key,
    required this.programName,
  });

  @override
  Widget build(BuildContext context) {
    // Sample timetable data
    final Map<String, Map<String, Map<String, dynamic>>> timetableData = {
      'Monday': {
        '7AM-10AM': {
          'unit': 'CIT 3150',
          'venue': 'TB 08',
          'lecturer': 'D. KITARIA',
        },
        '10AM-1PM': {
          'unit': 'CIT 3150',
          'venue': 'TB 08',
          'lecturer': 'Dr mwadulo',
        },
        '1PM-4PM': {
          'unit': 'CIT 3150',
          'venue': 'TB 08',
          'lecturer': 'Dr.chege',
        },
      },
      'Tuesday': {
        '7AM-10AM': {
          'unit': 'CIT 3154',
          'venue': 'TB 06',
          'lecturer': 'S. MAGETO',
        },
        '10AM-1PM': {
          'unit': 'CIT 3154',
          'venue': 'TB 02',
          'lecturer': 'Dr D.Bundi',
        },
        '1PM-4PM': {
          'unit': 'CIT 3154',
          'venue': 'ECB 05',
          'lecturer': 'S. MAGETO',
        },
      },
      'Wednesday': {
        '7AM-10AM': {
          'unit': 'CIT 3153',
          'venue': 'TB 11',
          'lecturer': 'A. IRUNGU',
        },
        '10AM-1PM': {
          'unit': 'CIT 3153',
          'venue': 'TB 11',
          'lecturer': 'A. IRUNGU',
        },
        '1PM-4PM': {
          'unit': 'CIT 3153',
          'venue': 'TB 11',
          'lecturer': 'A. IRUNGU',
        },
      },
      'Thursday': {
        '7AM-10AM': {
          'unit': 'CIT 3152',
          'venue': 'TB 02',
          'lecturer': 'D. KALUI',
        },
        '10AM-1PM': {
          'unit': 'CIT 3152',
          'venue': 'TB 02',
          'lecturer': 'D. KALUI',
        },
        '1PM-4PM': {
          'unit': 'CIT 3152',
          'venue': 'TB 02',
          'lecturer': 'D. KALUI',
        },
      },
      'Friday': {
        '7AM-10AM': {
          'unit': 'CCU 3150',
          'venue': 'TB 06',
          'lecturer': 'M. ASUNTA',
        },
        '10AM-1PM': {
          'unit': 'CCU 3150',
          'venue': 'TB 06',
          'lecturer': 'M. ASUNTA',
        },
        '1PM-4PM': {
          'unit': 'CCU 3150',
          'venue': 'TB 06',
          'lecturer': 'M. ASUNTA',
        },
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable: $programName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
            tooltip: 'Share',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timetable header
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: MustTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'MERU UNIVERSITY OF SCIENCE AND TECHNOLOGY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'SCHOOL OF COMPUTING AND INFORMATICS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'TIMETABLE: $programName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'January-May 2025',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Timetable
            for (final day in AppConstants.daysOfWeek) ...[
              Text(
                day,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              if (timetableData.containsKey(day) &&
                  timetableData[day]!.isNotEmpty)
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timetableData[day]!.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final timeSlot =
                          timetableData[day]!.keys.elementAt(index);
                      final session = timetableData[day]![timeSlot]!;

                      return ListTile(
                        leading: Container(
                          width: 80,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            timeSlot,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          session['unit'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(session['venue']),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(session['lecturer']),
                              ],
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Text(
                      'No classes scheduled for $day',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
