import 'package:flutter/material.dart';
import '../widgets/report_form_widget.dart';
import '../widgets/recent_reports_widget.dart';
import '../widgets/bottom_nav_widget.dart';
import '../styles/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: AppTheme.animationDuration,
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: AppTheme.animationCurve,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/reports');
        break;
      case 2:
        // Add new report - handled by FAB now
        _showAddReportDialog();
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _showAddReportDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppTheme.neutral200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Report New Issue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ReportFormWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primaryColor, AppTheme.primaryDark],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.neutral100,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CIVIC ISSUE',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.neutral100,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'REPORT SYSTEM',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutral100.withOpacity(0.8),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_rounded,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.report_rounded,
                  title: 'My Reports',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reports');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    _showHelpDialog();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsDialog();
                  },
                ),
                const Divider(height: 1),
                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : AppTheme.neutral600,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDestructive ? AppTheme.errorColor : AppTheme.neutral700,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline_rounded, color: AppTheme.infoColor),
            const SizedBox(width: 8),
            const Text('Help & Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to report an issue:'),
            SizedBox(height: 8),
            Text('1. Select issue category\n2. Add location details\n3. Write description\n4. Add photos/videos\n5. Submit report'),
            SizedBox(height: 16),
            Text('For technical support, contact: support@civicreporter.com'),
          ],
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.settings_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Settings'),
          ],
        ),
        content: const Text('Settings panel will be available in future updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.errorColor),
            const SizedBox(width: 8),
            const Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral200,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'CIVIC ISSUE',
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'REPORT SYSTEM',
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications'),
                  backgroundColor: AppTheme.infoColor,
                ),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      drawer: _buildDrawer(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            RecentReportsWidget(),
            SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _showAddReportDialog,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Report Issue'),
          elevation: 6,
          heroTag: 'main_fab',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
