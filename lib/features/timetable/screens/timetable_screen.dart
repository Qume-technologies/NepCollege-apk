import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timetable_provider.dart';
import '../widgets/day_selector.dart';
import '../widgets/schedule_card.dart';

class TimetableScreen extends ConsumerStatefulWidget {
  const TimetableScreen({super.key});

  @override
  ConsumerState<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends ConsumerState<TimetableScreen> {
  int _selectedDayIndex = 0;
  final List<String> _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final timetableAsync = ref.watch(timetableProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Academic Timetable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: timetableAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading timetable: $err')),
        data: (allTimetableData) {
          final dailyClasses = allTimetableData.where((item) => (item['day_of_week'] as num?)?.toInt() == (_selectedDayIndex + 1)).toList();

          return Column(
            children: [
              DaySelector(
                days: _days,
                selectedIndex: _selectedDayIndex,
                onDaySelected: (idx) => setState(() => _selectedDayIndex = idx),
              ),
              Expanded(
                child: dailyClasses.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy_rounded, color: theme.hintColor, size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'Seems to be a holiday! 🌴',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Enjoy your free time. There are no classes scheduled for this day.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(timetableProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: dailyClasses.length,
                        itemBuilder: (context, index) => ScheduleCard(classInfo: dailyClasses[index]),
                      ),
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
