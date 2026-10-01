import 'package:flutter/material.dart';
import '../widgets/legal_section_card.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Bridgewater App Terms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Last Updated: October 2026', style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 24),
            LegalSectionCard(
              title: '1. Acceptance of Terms', 
              body: 'By accessing or using the Bridgewater College application, you agree to be bound by these terms and conditions.',
            ),
            LegalSectionCard(
              title: '2. Student Responsibilities', 
              body: 'You are responsible for maintaining the confidentiality of your credentials and for all activities conducted through your account.',
            ),
            LegalSectionCard(
              title: '3. Academic Integrity', 
              body: 'Any unauthorized modification of grades, attendance tampering, or misuse of the academic portal will result in disciplinary action.',
            ),
            LegalSectionCard(
              title: '4. System Availability', 
              body: 'While we strive for 99.9% uptime, Bridgewater College reserves the right to perform scheduled system maintenance and upgrades as required.',
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
