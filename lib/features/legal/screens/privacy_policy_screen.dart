import 'package:flutter/material.dart';
import '../widgets/legal_section_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Bridgewater Privacy Policy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Effective Date: October 2026', style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 24),
            LegalSectionCard(
              title: '1. Information We Collect', 
              body: 'Bridgewater International College collects personal data including student ID, name, email address, attendance records, exam results, and fee transactions to facilitate your academic journey.',
            ),
            LegalSectionCard(
              title: '2. How We Use Your Data', 
              body: 'Your data is exclusively utilized for academic administration, attendance monitoring, notification alerts, and student support services.',
            ),
            LegalSectionCard(
              title: '3. Data Protection & Security', 
              body: 'We implement strong encryption protocols, row-level security on databases, and biometric verification key generation on-device to ensure your data remains confidential.',
            ),
            LegalSectionCard(
              title: '4. Third-Party Services', 
              body: 'We do not sell or rent student data. Limited credentials may interact with secured AI assistant models (e.g. Mistral AI) or payment gateways (eSewa / Khalti) solely for intended app functions.',
            ),
            LegalSectionCard(
              title: '5. Contact Us', 
              body: 'For privacy concerns or data inquiry requests, please contact privacy@bridgewater.edu.np.',
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
