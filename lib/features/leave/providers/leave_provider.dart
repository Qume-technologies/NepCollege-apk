import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

class LeaveNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref _ref;

  LeaveNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadLeaves();
  }

  Future<void> loadLeaves() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final data = await academicService.getLeaveNotes();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> submitLeave(String subject, String description, String startDate, String endDate) async {
    final academicService = _ref.read(academicServiceProvider);

    final newLeave = {
      'subject': subject,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'status': 'Pending',
      'created_at': DateTime.now().toIso8601String(),
    };

    // Optimistically update
    final currentData = state.value ?? [];
    state = AsyncValue.data([newLeave, ...currentData]);

    final success = await academicService.submitLeaveNote(subject, description, startDate, endDate);
    if (!success) {
      // Rollback on error
      state = AsyncValue.data(currentData);
    }
    return success;
  }

  Future<void> refresh() async {
    await loadLeaves();
  }
}

final leaveProvider = StateNotifierProvider<LeaveNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return LeaveNotifier(ref);
});
