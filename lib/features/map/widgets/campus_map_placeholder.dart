import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CampusMapPlaceholder extends StatelessWidget {
  const CampusMapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.map_outlined, size: 100, color: AppTheme.gold),
        const SizedBox(height: 20),
        const Text(
          'Interactive Map Coming Soon',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'We are currently integrating the campus GPS coordinates for a better experience.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.crimson,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text('Back to Dashboard'),
        ),
      ],
    );
  }
}
