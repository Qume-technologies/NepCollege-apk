import 'package:flutter/material.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final double percentage;
  final int present;
  final int total;

  const AttendanceSummaryCard({
    super.key,
    required this.percentage,
    required this.present,
    required this.total,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Overall Present', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('${percentage.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white12,
                child: Icon(Icons.show_chart_rounded, color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryStat('Lectures', '$total'),
              _buildSummaryStat('Present', '$present'),
              _buildSummaryStat('Absent', '${total - present}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
