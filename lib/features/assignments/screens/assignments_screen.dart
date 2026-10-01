import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/assignments_provider.dart';
import '../widgets/task_progress_card.dart';
import '../widgets/task_card.dart';

class AssignmentsScreen extends ConsumerWidget {
  final List<Map<String, dynamic>>? assignments;
  final String studentId;

  const AssignmentsScreen({super.key, this.assignments, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final assignmentsAsync = ref.watch(assignmentsProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('My Assignments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: assignmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading assignments: $err')),
        data: (taskList) {
          final list = assignments ?? taskList;

          return RefreshIndicator(
            onRefresh: () => ref.read(assignmentsProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskProgressCard(totalTasks: list.length),
                    const SizedBox(height: 32),
                    const Text('Pending Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    if (list.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'There\'s no assignment for u',
                            style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    else
                      ...list.map((a) {
                        final dueDate = DateTime.parse(a['due_date'].toString());
                        final formatter = dueDate.day == DateTime.now().day && dueDate.month == DateTime.now().month && dueDate.year == DateTime.now().year ? 'Today' : '${dueDate.day}/${dueDate.month}';
                        final subjectCode = a['subject']?.toString().substring(0, a['subject'].toString().length > 2 ? 3 : a['subject'].toString().length).toUpperCase() ?? 'HW';
                        
                        return TaskCard(
                          assignment: a,
                          title: a['title'] ?? 'Task',
                          date: 'Due: $formatter',
                          subject: subjectCode,
                        );
                      }),
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
}
