import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

class AttendanceNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref _ref;

  AttendanceNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final data = await academicService.getAttendance();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadAttendance();
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return AttendanceNotifier(ref);
});
