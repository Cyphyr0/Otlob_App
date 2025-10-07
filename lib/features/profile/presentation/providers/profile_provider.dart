import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/service_locator.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) => getIt<ProfileRepository>());

final profileProvider = StateNotifierProvider.family<ProfileNotifier, AsyncValue<Profile?>, String>((ref, userId) => ProfileNotifier(ref.watch(profileRepositoryProvider), userId));

final currentUserProfileProvider = Provider<AsyncValue<Profile?>>((ref) {
  // For now, return null - this should be connected to actual auth state
  // TODO: Connect to Firebase Auth state provider
  return const AsyncValue.data(null);
});

class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {

  ProfileNotifier(this._repository, this._userId) : super(const AsyncValue.loading()) {
    loadProfile();
  }
  final ProfileRepository _repository;
  final String _userId;

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getProfile(_userId);
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createProfile(Profile profile) async {
    state = const AsyncValue.loading();
    try {
      final createdProfile = await _repository.createProfile(profile);
      state = AsyncValue.data(createdProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProfile(Profile profile) async {
    state = const AsyncValue.loading();
    try {
      final updatedProfile = await _repository.updateProfile(profile);
      state = AsyncValue.data(updatedProfile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  Future<bool> profileExists() async {
    try {
      return await _repository.profileExists(_userId);
    } catch (error) {
      return false;
    }
  }
}

// Provider for auth state (assuming it exists in your auth feature)
final authStateProvider = StreamProvider((ref) {
  // This should be connected to your Firebase Auth state
  // For now, returning a placeholder - replace with actual auth state
  return Stream.value(null);
});