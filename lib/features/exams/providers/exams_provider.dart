import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';
import '../../profile/providers/profile_provider.dart';

class ExamsNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref _ref;

  ExamsNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadExams();
  }

  Future<void> loadExams() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final profileState = _ref.read(profileProvider);
      final profile = profileState.asData?.value;

      final data = await academicService.getExams(
        department: profile?['department'],
      );
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadExams();
  }
}

final examsProvider = StateNotifierProvider<ExamsNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return ExamsNotifier(ref);
});
