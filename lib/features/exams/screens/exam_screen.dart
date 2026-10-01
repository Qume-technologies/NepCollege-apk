import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exams_provider.dart';
import '../widgets/exam_item_card.dart';

class ExamScreen extends ConsumerWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final examsAsync = ref.watch(examsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Examination Center', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: examsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading exams: $err')),
        data: (exams) {
          return RefreshIndicator(
            onRefresh: () => ref.read(examsProvider.notifier).refresh(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Upcoming Exams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (exams.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text("There's no upcoming exams.", style: TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    )
                  else
                    ...exams.map((exam) => ExamItemCard(
                      title: exam['title']?.toString() ?? 'Exam',
                      startDate: exam['start_date']?.toString() ?? 'TBA',
                      endDate: exam['end_date']?.toString() ?? 'TBA',
                      type: exam['exam_type']?.toString() ?? 'Exam',
                    )),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
