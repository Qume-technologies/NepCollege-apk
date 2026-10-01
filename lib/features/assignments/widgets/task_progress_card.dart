import 'package:flutter/material.dart';

class TaskProgressCard extends StatelessWidget {
  final int totalTasks;

  const TaskProgressCard({super.key, required this.totalTasks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Active Assignments', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Text('$totalTasks Total Tasks', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('All pending and upcoming tasks', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Stack(
            alignment: Alignment.center,
            children: const [
              SizedBox(height: 70, width: 70, child: CircularProgressIndicator(value: 1.0, color: Colors.white24, strokeWidth: 8)),
              Icon(Icons.assignment_outlined, color: Colors.white, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
