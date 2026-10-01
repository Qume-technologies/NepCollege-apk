import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';
import '../../profile/providers/profile_provider.dart';

class NoticesNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref _ref;

  NoticesNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadNotices();
  }

  Future<void> loadNotices() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final profileState = _ref.read(profileProvider);
      final profile = profileState.asData?.value;

      final data = await academicService.getNotices(
        department: profile?['department'],
        roomNo: profile?['room_no']?.toString(),
      );
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadNotices();
  }
}

final noticesProvider = StateNotifierProvider<NoticesNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return NoticesNotifier(ref);
});
