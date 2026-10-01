import 'package:flutter/material.dart';

class GpaHeaderCard extends StatelessWidget {
  final double gpa;
  final int? rank;

  const GpaHeaderCard({
    super.key,
    required this.gpa,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          const Text('Latest Exam GPA', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(gpa.toStringAsFixed(2), style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(rank != null ? Icons.emoji_events_rounded : Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 6),
              Text(rank != null ? 'College Rank: #$rank' : 'Academic Standing: Good', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
