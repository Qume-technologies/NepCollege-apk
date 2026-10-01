import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> classInfo;

  const ScheduleCard({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(classInfo['time_start'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Container(
                height: 30,
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
              Text(classInfo['time_end'] ?? '', style: TextStyle(color: theme.hintColor, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(classInfo['subject_name'] ?? 'Class', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.meeting_room_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(classInfo['room_number'] ?? 'Auditorium', style: TextStyle(color: theme.hintColor, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(classInfo['teacher_name'] ?? 'Faculty', style: TextStyle(color: theme.hintColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
