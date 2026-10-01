import 'package:flutter/material.dart';

class FeesSummaryCard extends StatelessWidget {
  final double outstanding;

  const FeesSummaryCard({super.key, required this.outstanding});

  @override
  Widget build(BuildContext context) {
    final hasDues = outstanding > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: hasDues ? const Color(0xFFFF5252) : const Color(0xFF00BFA5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: (hasDues ? Colors.red : const Color(0xFF00BFA5)).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          const Text('Remaining Outstanding', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text('Rs. ${outstanding.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(hasDues ? Icons.info_outline : Icons.check_circle_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(hasDues ? 'Payment pending' : 'All dues cleared', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
