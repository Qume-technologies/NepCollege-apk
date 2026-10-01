import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> assignment;
  final String title;
  final String date;
  final String subject;

  const TaskCard({
    super.key,
    required this.assignment,
    required this.title,
    required this.date,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF222222) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded))
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(subject, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                  Text('Due Date:', style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(date, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 16),
                  Text('Description & Links:', style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(assignment['description']?.toString() ?? 'No description provided.', style: const TextStyle(fontSize: 14, height: 1.5)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                subject,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
