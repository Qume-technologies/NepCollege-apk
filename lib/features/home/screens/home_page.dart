import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bridgewatercollege/core/theme/app_theme.dart';
import '../widgets/action_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'BRIDGEWATER COLLEGE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTheme.crimson, AppTheme.darkBg],
                      ),
                    ),
                  ),
                  Center(
                    child: const Icon(
                      Icons.school_rounded,
                      size: 100,
                      color: AppTheme.gold,
                    ).animate().scale(duration: 1.seconds, curve: Curves.easeOutBack),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Welcome to the future of learning.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.gold,
                  ),
                ).animate().fadeIn(delay: 500.ms).slideX(),
                const SizedBox(height: 30),
                const ActionCard(
                  title: 'Admissions',
                  subtitle: 'Start your journey today',
                  icon: Icons.assignment_ind_rounded,
                  color: AppTheme.crimson,
                ).animate().fadeIn(delay: 700.ms).moveY(begin: 30, end: 0),
                const SizedBox(height: 15),
                ActionCard(
                  title: 'Campus Life',
                  subtitle: 'Connect with your community',
                  icon: Icons.people_alt_rounded,
                  color: Colors.blueGrey[800]!,
                ).animate().fadeIn(delay: 900.ms).moveY(begin: 30, end: 0),
                const SizedBox(height: 15),
                ActionCard(
                  title: 'Events',
                  subtitle: 'Never miss a moment',
                  icon: Icons.event_available_rounded,
                  color: AppTheme.gold.withValues(alpha: 0.8),
                  textColor: Colors.black,
                ).animate().fadeIn(delay: 1100.ms).moveY(begin: 30, end: 0),
                const SizedBox(height: 15),
                const ActionCard(
                  title: 'Athletics',
                  subtitle: 'Go Eagles!',
                  icon: Icons.sports_football_rounded,
                  color: AppTheme.crimson,
                ).animate().fadeIn(delay: 1300.ms).moveY(begin: 30, end: 0),
                const SizedBox(height: 50),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.surfaceDark,
        selectedItemColor: AppTheme.gold,
        unselectedItemColor: Colors.white54,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/map');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
