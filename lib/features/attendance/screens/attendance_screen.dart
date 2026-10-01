import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_provider.dart';
import '../widgets/attendance_summary_card.dart';
import '../widgets/attendance_item_card.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final attendanceAsync = ref.watch(attendanceProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Attendance History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: attendanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading attendance: $err')),
        data: (attendanceData) {
          int totalPresent = 0;
          int totalDays = 0;
          for (var item in attendanceData) {
            totalPresent += (item['present_days'] as num? ?? 0).toInt();
            totalDays += (item['total_days'] as num? ?? 0).toInt();
          }
          double overallPercentage = totalDays == 0 ? 0.0 : (totalPresent / totalDays) * 100;

          return RefreshIndicator(
            onRefresh: () => ref.read(attendanceProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AttendanceSummaryCard(
                      percentage: overallPercentage,
                      present: totalPresent,
                      total: totalDays,
                    ),
                    const SizedBox(height: 24),
                    const Text('Monthly Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    if (attendanceData.isEmpty)
                      const Center(child: Text('No attendance records for this year.', style: TextStyle(color: Colors.grey))),
                    ...attendanceData.map((item) => AttendanceItemCard(
                      title: item['month_name'] ?? 'Month', 
                      present: (item['present_days'] as num? ?? 0).toInt(), 
                      total: (item['total_days'] as num? ?? 0).toInt(), 
                      color: _getMonthColor(item['month_name'] ?? ''),
                    )),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getMonthColor(String month) {
    if (month.contains('Jan') || month.contains('Feb')) return Colors.blueAccent;
    if (month.contains('Mar') || month.contains('Apr')) return Colors.green;
    return Colors.orange;
  }
}
