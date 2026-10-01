import 'package:flutter/material.dart';
import '../../leave/screens/leave_note_screen.dart';
import '../../notices/screens/notices_screen.dart';
import '../../profile/screens/profile_details_screen.dart';

class DashboardQuickActions extends StatelessWidget {
  final List<Map<String, dynamic>> notices;
  final ValueChanged<int> onTabSelected;

  const DashboardQuickActions({
    super.key,
    required this.notices,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      {'icon': Icons.assignment_turned_in_rounded, 'label': 'Attendance', 'color': Colors.green, 'route': '/attendance'},
      {'icon': Icons.calendar_month_rounded, 'label': 'Timetable', 'color': Colors.blue, 'route': '/timetable'},
      {'icon': Icons.payment_rounded, 'label': 'Fees', 'color': Colors.teal, 'route': '/fees'},
      {'icon': Icons.grade_rounded, 'label': 'Results', 'color': Colors.amber, 'route': '/results'},
      {'icon': Icons.library_books_rounded, 'label': 'Notices', 'color': Colors.purple, 'route': '/notices'},
      {'icon': Icons.quiz_rounded, 'label': 'Exam', 'color': Colors.orange, 'route': '/exam'},
      {'icon': Icons.note_alt_rounded, 'label': 'Leave Note', 'color': Colors.blueAccent, 'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveNoteScreen()))},
      {'icon': Icons.map_rounded, 'label': 'Campus Map', 'color': Colors.redAccent, 'route': '/map'},
      {'icon': Icons.help_outline_rounded, 'label': 'Support', 'color': Colors.indigo, 'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreens.help()))},
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: () {
            if (action.containsKey('route')) {
              final route = action['route'] as String;
              if (route == '/attendance') {
                onTabSelected(1);
              } else if (route == '/assignments') {
                onTabSelected(2);
              } else if (route == '/notices') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NoticesScreen(notices: notices)));
              } else {
                Navigator.pushNamed(context, route);
              }
            } else if (action.containsKey('action')) {
              final actionFunc = action['action'] as Function(BuildContext);
              actionFunc(context);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: theme.brightness == Brightness.light
                  ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action['icon'] as IconData, color: action['color'] as Color, size: 28),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
