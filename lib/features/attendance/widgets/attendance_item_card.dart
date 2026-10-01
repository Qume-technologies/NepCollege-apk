import 'package:flutter/material.dart';

class AttendanceItemCard extends StatelessWidget {
  final String title;
  final int present;
  final int total;
  final Color color;

  const AttendanceItemCard({
    super.key,
    required this.title,
    required this.present,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = total == 0 ? 0.0 : present / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('$present / $total', style: TextStyle(color: theme.hintColor, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[100],
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.pie_chart_outline_rounded, size: 14, color: color),
              const SizedBox(width: 6),
              Text('${(ratio * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              const Spacer(),
              const Text('Target: 75%', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
