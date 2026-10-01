import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';
import '../../profile/providers/profile_provider.dart';

class TimetableNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref _ref;

  TimetableNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final profileState = _ref.read(profileProvider);
      final profile = profileState.asData?.value;

      final data = await academicService.getTimetable(
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
    await loadTimetable();
  }
}

final timetableProvider = StateNotifierProvider<TimetableNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return TimetableNotifier(ref);
});
