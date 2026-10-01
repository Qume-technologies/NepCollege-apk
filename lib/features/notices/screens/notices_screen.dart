import 'package:flutter/material.dart';
import '../widgets/notice_card.dart';

class NoticesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notices;
  const NoticesScreen({super.key, required this.notices});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Departmental Notices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notices.isEmpty 
             ? [const Center(child: Padding(padding: EdgeInsets.only(top: 50), child: Text('No notices available.', style: TextStyle(color: Colors.grey))))]
             : notices.map((n) {
                  final title = n['title']?.toString() ?? 'Notice';
                  final desc = n['content']?.toString() ?? n['desc']?.toString() ?? '';
                  
                  String timeStr = 'Just now';
                  if (n['created_at'] != null) {
                    final date = DateTime.parse(n['created_at'].toString());
                    final diff = DateTime.now().difference(date);
                    if (diff.inDays > 0) {
                      timeStr = '${diff.inDays}d ago';
                    } else if (diff.inHours > 0) timeStr = '${diff.inHours}h ago';
                    else if (diff.inMinutes > 0) timeStr = '${diff.inMinutes}m ago';
                  }

                  return NoticeCard(
                    title: title, 
                    desc: desc, 
                    time: timeStr, 
                    icon: Icons.campaign_rounded, 
                    color: theme.colorScheme.primary,
                  );
               }).toList(),
          ),
        ),
      ),
    );
  }
}
