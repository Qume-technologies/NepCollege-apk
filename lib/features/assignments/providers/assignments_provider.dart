import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';
import '../../profile/providers/profile_provider.dart';

class AssignmentsNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref _ref;

  AssignmentsNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final profileState = _ref.read(profileProvider);
      final profile = profileState.asData?.value;

      final data = await academicService.getAssignments(
        department: profile?['department'],
        year: (profile?['admission_year'] as num?)?.toInt(),
        roomNo: profile?['room_no'],
      );
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadAssignments();
  }
}

final assignmentsProvider = StateNotifierProvider<AssignmentsNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return AssignmentsNotifier(ref);
});
