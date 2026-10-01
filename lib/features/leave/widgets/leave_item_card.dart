import 'package:flutter/material.dart';

class LeaveItemCard extends StatelessWidget {
  final Map<String, dynamic> leave;

  const LeaveItemCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final status = leave['status']?.toString() ?? 'Pending';
    final subject = leave['subject']?.toString() ?? 'Leave Note';
    final reason = leave['description']?.toString() ?? leave['reason']?.toString() ?? '';
    final adminReply = leave['admin_reply']?.toString() ?? '';
    final startDate = leave['start_date']?.toString() ?? '';
    final endDate = leave['end_date']?.toString() ?? '';
    
    final dateDisplay = (endDate.trim().isNotEmpty) ? '$startDate  →  $endDate' : startDate;
    
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.hourglass_empty_rounded;
    
    if (status.toLowerCase() == 'accepted' || status.toLowerCase() == 'approved') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
    } else if (status.toLowerCase() == 'rejected') {
      statusColor = Colors.redAccent;
      statusIcon = Icons.cancel_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withValues(alpha: 0.1),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 14, color: theme.hintColor),
                    const SizedBox(width: 6),
                    Text(dateDisplay, style: TextStyle(color: theme.hintColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(reason, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 13, height: 1.4)),
                if (adminReply.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey[100],
                      border: Border(left: BorderSide(color: statusColor, width: 3)),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Reply:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                        const SizedBox(height: 4),
                        Text(adminReply, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black87, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
