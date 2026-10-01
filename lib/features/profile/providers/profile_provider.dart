import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final Ref _ref;

  ProfileNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profileService = _ref.read(profileServiceProvider);
      final profile = await profileService.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return ProfileNotifier(ref);
});
