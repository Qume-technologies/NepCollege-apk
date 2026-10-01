import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bridgewatercollege/core/config/app_config.dart';
import 'package:bridgewatercollege/core/providers/theme_provider.dart';
import 'package:bridgewatercollege/core/screens/splash_screen.dart';
import 'package:bridgewatercollege/features/auth/screens/login_screen.dart';
import 'package:bridgewatercollege/features/auth/screens/signup_screen.dart';
import 'package:bridgewatercollege/features/dashboard/screens/dashboard_screen.dart';
import 'package:bridgewatercollege/features/timetable/screens/timetable_screen.dart';
import 'package:bridgewatercollege/features/attendance/screens/attendance_screen.dart';
import 'package:bridgewatercollege/features/results/screens/results_screen.dart';
import 'package:bridgewatercollege/features/exams/screens/exam_screen.dart';
import 'package:bridgewatercollege/features/fees/screens/fees_screen.dart';
import 'package:bridgewatercollege/features/map/screens/map_page.dart';
import 'package:bridgewatercollege/features/security/screens/biometric_gate_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Dotenv load warning: $e');
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ref.watch(themeManagerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bridgewater College',
      themeMode: themeManager.themeMode, 
      theme: themeManager.lightTheme,
      darkTheme: themeManager.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const BiometricGateScreen(child: DashboardScreen()),
        '/timetable': (context) => const TimetableScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/results': (context) => const ResultsScreen(),
        '/exam': (context) => const ExamScreen(),
        '/fees': (context) => const FeesScreen(),
        '/map': (context) => const MapPage(),
      },
    );
  }
}
