import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('student_id');

    if (!mounted) return;
    if (studentId != null && studentId.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.surfaceLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Animated Icon Container
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppTheme.crimson, AppTheme.crimson.withRed(180)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.crimson.withValues(alpha: 0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 72,
                color: AppTheme.gold,
              ),
            )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .shimmer(delay: 900.ms, duration: 1000.ms, color: Colors.white24),

            const SizedBox(height: 32),

            // College Title
            Text(
              'BRIDGEWATER',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                color: isDark ? Colors.white : Colors.black87,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 6),

            Text(
              'COLLEGE',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 4,
                color: AppTheme.crimson,
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms),

            const SizedBox(height: 12),

            Text(
              'Empowering Future Leaders',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: theme.hintColor,
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 600.ms),

            const Spacer(),

            // Loading indicator & version
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: theme.colorScheme.primary,
              ),
            ).animate().fadeIn(delay: 1000.ms),

            const SizedBox(height: 20),

            Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: theme.hintColor.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
