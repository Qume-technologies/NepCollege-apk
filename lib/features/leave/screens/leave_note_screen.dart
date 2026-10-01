import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/leave_provider.dart';
import '../widgets/leave_item_card.dart';

class LeaveNoteScreen extends ConsumerStatefulWidget {
  const LeaveNoteScreen({super.key});

  @override
  ConsumerState<LeaveNoteScreen> createState() => _LeaveNoteScreenState();
}

class _LeaveNoteScreenState extends ConsumerState<LeaveNoteScreen> {
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _showLeaveNoteDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final subjectController = TextEditingController();
    final descController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> pickStartDate() async {
            final picked = await showDatePicker(
              context: context,
              initialDate: startDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 180)),
            );
            if (picked != null) {
              setDialogState(() {
                startDate = picked;
                startDateController.text = _formatDate(picked);
                if (endDate != null && endDate!.isBefore(startDate!)) {
                  endDate = null;
                  endDateController.clear();
                }
              });
            }
          }

          Future<void> pickEndDate() async {
            if (startDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a Start Date first!')));
              return;
            }
            final picked = await showDatePicker(
              context: context,
              initialDate: endDate ?? startDate!,
              firstDate: startDate!,
              lastDate: DateTime.now().add(const Duration(days: 180)),
            );
            if (picked != null) {
              setDialogState(() {
                endDate = picked;
                endDateController.text = _formatDate(picked);
              });
            }
          }

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            contentPadding: const EdgeInsets.all(24),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.note_add_outlined, color: Colors.blueAccent, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Text('Apply for Leave', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      hintText: 'e.g. Sick Leave',
                      filled: true,
                      fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.subject_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startDateController,
                          readOnly: true,
                          onTap: pickStartDate,
                          decoration: InputDecoration(
                            labelText: 'From',
                            hintText: 'Start',
                            filled: true,
                            fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            prefixIcon: const Icon(Icons.date_range_rounded, size: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: endDateController,
                          readOnly: true,
                          onTap: pickEndDate,
                          decoration: InputDecoration(
                            labelText: 'To (Opt)',
                            hintText: 'End',
                            filled: true,
                            fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            prefixIcon: const Icon(Icons.event_busy_rounded, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Reason Description',
                      hintText: 'Detailed explanation...',
                      filled: true,
                      fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (subjectController.text.trim().isEmpty || 
                            descController.text.trim().isEmpty || 
                            startDateController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields!')));
                          return;
                        }
                        
                        final subjectText = subjectController.text.trim();
                        final descText = descController.text.trim();
                        final startText = startDateController.text.trim();
                        final endText = endDateController.text.trim();
                        
                        Navigator.pop(context);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Submitting application...'), backgroundColor: Colors.blueAccent)
                        );

                        final success = await ref.read(leaveProvider.notifier).submitLeave(
                          subjectText,
                          descText,
                          startText,
                          endText,
                        );

                        if (mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Leave application successfully submitted!'), backgroundColor: Colors.green)
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to submit. Saved to offline queue.'), backgroundColor: Colors.orange)
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('SUBMIT APPLICATION', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final leavesAsync = ref.watch(leaveProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Leave Applications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showLeaveNoteDialog,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: leavesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading leave notes: $err')),
        data: (leaves) {
          return RefreshIndicator(
            onRefresh: () => ref.read(leaveProvider.notifier).refresh(),
            child: leaves.isEmpty 
              ? ListView(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text("You haven't requested any leaves yet.", style: TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: leaves.length,
                  itemBuilder: (context, index) {
                    return LeaveItemCard(leave: leaves[index]);
                  },
                ),
          );
        },
      ),
    );
  }
}
