import 'package:flutter/material.dart';

class ContactFieldInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType type;
  final bool isDark;

  const ContactFieldInput({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.type,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
