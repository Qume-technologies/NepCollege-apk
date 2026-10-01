import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/results_provider.dart';
import '../widgets/gpa_header_card.dart';
import '../widgets/semester_result_card.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resultsAsync = ref.watch(resultsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Academic Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading results: $err')),
        data: (dataObj) {
          final resultsData = dataObj.results;
          final rank = dataObj.rank;

          Map<String, List<Map<String, dynamic>>> groupedResults = {};
          for (var res in resultsData) {
            final examTitle = res['exam_title']?.toString() ?? 'General Exam';
            groupedResults.putIfAbsent(examTitle, () => []).add(res);
          }

          double latestGPA = 0.0;
          if (resultsData.isNotEmpty) {
            latestGPA = (resultsData.first['gpa'] as num?)?.toDouble() ?? 0.0;
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(resultsProvider.notifier).refresh(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GpaHeaderCard(gpa: latestGPA, rank: rank),
                  const SizedBox(height: 24),
                  const Text('Semester-wise Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (resultsData.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('No results records available.', style: TextStyle(color: Colors.grey)),
                    )),
                  ...groupedResults.entries.map((entry) {
                    double semGPA = 0;
                    for (var r in entry.value) { semGPA += (r['gpa'] as num? ?? 0).toDouble(); }
                    semGPA = entry.value.isEmpty ? 0 : semGPA / entry.value.length;
                    
                    return SemesterResultCard(
                      title: entry.key, 
                      gpa: semGPA.toStringAsFixed(2), 
                      results: entry.value,
                    );
                  }),
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
