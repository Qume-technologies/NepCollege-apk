import 'package:flutter/material.dart';

class ExamItemCard extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String type;

  const ExamItemCard({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(type, style: TextStyle(color: theme.colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 14, color: theme.hintColor),
                    const SizedBox(width: 4),
                    Text('$startDate - $endDate', style: TextStyle(color: theme.hintColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.article_outlined, size: 28, color: Colors.grey),
        ],
      ),
    );
  }
}
