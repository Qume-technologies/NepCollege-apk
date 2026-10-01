import 'package:flutter/material.dart';

class DashboardAttendanceBoard extends StatelessWidget {
  final Map<String, dynamic>? attendance;
  final VoidCallback onTap;

  const DashboardAttendanceBoard({
    super.key,
    required this.attendance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (attendance == null || attendance!['total_classes'] == 0) {
      return Center(
        child: Column(
          children: const [
            Icon(Icons.inbox_outlined, color: Colors.grey, size: 40),
            SizedBox(height: 12),
            Text('No attendance records yet', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      );
    }

    final total = attendance!['total_classes'] as int;
    final present = attendance!['present_classes'] as int;
    final percentage = total == 0 ? 0.0 : (present / total) * 100;
    final isLow = percentage < 75;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)]
                : [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[100],
                    color: isLow ? Colors.redAccent : Colors.blueAccent,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percentage.toInt()}%',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text('Total', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Attendance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isLow ? 'Warning: Low attendance' : 'Great progress! Keep it up.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isLow ? Colors.redAccent : Colors.grey,
                      fontWeight: isLow ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMiniStat('Present', '$present', Colors.green),
                      const SizedBox(width: 16),
                      _buildMiniStat('Absent', '${total - present}', Colors.redAccent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
