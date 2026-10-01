import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

class FeesNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref _ref;

  FeesNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadFees();
  }

  Future<void> loadFees() async {
    state = const AsyncValue.loading();
    try {
      final academicService = _ref.read(academicServiceProvider);
      final data = await academicService.getFees();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadFees();
  }
}

final feesProvider = StateNotifierProvider<FeesNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return FeesNotifier(ref);
});
