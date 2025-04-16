import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../models/user.dart';
import '../../theme/must_theme.dart';
import '../auth/login_screen.dart';
import 'lecturers/manage_lecturers_screen.dart';
import 'units/manage_units_screen.dart';
import 'venues/manage_venues_screen.dart';
import 'programs/manage_programs_screen.dart';
import 'timetable/generate_timetable_screen.dart';
import 'timetable/view_timetables_screen.dart';

class AdminDashboard extends StatefulWidget {
  final User user;

  const AdminDashboard({super.key, required this.user});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  late final List<Map<String, dynamic>> _menuItems = [
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Administrator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildDashboardContent(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.user.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: MustTheme.lightGreen,
              child: Text(
                widget.user.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                  color: MustTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: MustTheme.primaryGreen,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return ListTile(
                  leading: Icon(
                    item['icon'],
                    color: _selectedIndex == index 
                        ? MustTheme.primaryGreen 
                        : Colors.grey[700],
                  ),
                  title: Text(item['title']),
                  selected: _selectedIndex == index,
                  selectedTileColor: MustTheme.lightGreen,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to help
              Navigator.pop(context);
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
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
                  title: 'Current Session',
                  value: AppConstants.currentSession,
                  icon: Icons.calendar_month,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  title: 'Departments',
                  value: 'Computer Science, IT',
                  icon: Icons.business,
                  color: Colors.orange,
                ),
                _buildStatCard(
                  title: 'Generated Timetables',
                  value: '6 Programs',
                  icon: Icons.schedule,
                  color: Colors.green,
                ),
                _buildStatCard(
                  title: 'Active Lecturers',
                  value: '32',
                  icon: Icons.person,
                  color: Colors.purple,
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
          
          // Menu Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return _buildMenuCard(
                  title: item['title'],
                  icon: item['icon'],
                  count: item['count'],
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
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
    );
  }

  Widget _buildStatCard({
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

  Widget _buildMenuCard({
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

  void _refreshData() {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing data...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const SizedBox(
          width: 300,
          height: 300,
          child: Center(
            child: Text('No new notifications'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}