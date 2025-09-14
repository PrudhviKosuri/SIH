import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/profile_screen.dart';
import 'styles/app_theme.dart';
import 'services/location_service.dart';
import 'providers/reports_provider.dart';
import 'utils/page_transitions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request location permission on app startup
  final locationService = LocationService();
  await locationService.requestLocationPermission();
  
  runApp(const CivicIssueReporterApp());
}

class CivicIssueReporterApp extends StatelessWidget {
  const CivicIssueReporterApp({super.key});
  
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return CustomPageTransitions.fade(const SplashScreen(), settings: settings);
      case '/language':
        return CustomPageTransitions.slideFromRight(const LanguageSelectionScreen(), settings: settings);
      case '/login':
        return CustomPageTransitions.slideFromBottom(const LoginScreen(), settings: settings);
      case '/':
        return CustomPageTransitions.scale(const DashboardScreen(), settings: settings);
      case '/reports':
        return CustomPageTransitions.slideFromRight(const ReportsScreen(), settings: settings);
      case '/profile':
        return CustomPageTransitions.slideFromLeft(const ProfileScreen(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
          settings: settings,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReportsProvider(),
      child: MaterialApp(
        title: 'Civic Issue Reporter',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        onGenerateRoute: _generateRoute,
      ),
    );
  }
}
