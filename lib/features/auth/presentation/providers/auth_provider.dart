import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otlob_app/core/errors/failures.dart';
import 'package:otlob_app/core/utils/shared_prefs_helper.dart';
import 'package:otlob_app/features/auth/domain/entities/user.dart';
import 'package:otlob_app/features/auth/domain/repositories/auth_repository.dart';

class AuthStateNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // Check initial auth state from shared prefs
    final isAuthenticated = await SharedPrefsHelper.isAuthenticated();
    if (isAuthenticated) {
      // In real app, get user from Firebase or local DB
      // For mock, return a dummy user
      return User(
        id: 'mock_user_id',
        email: 'mock@example.com',
        name: 'Mock User',
        createdAt: DateTime.now(),
      );
    }
    return null;
  }

  Future<void> sendOTP(String phoneNumber) async {
    state = const AsyncValue.loading();
    try {
      // Mock: Simulate sending OTP
      // In real: Call repository.sendOTP(phoneNumber)
      await Future.delayed(const Duration(seconds: 1));
      if (phoneNumber.length < 10) {
        throw AuthFailure(message: 'Invalid phone number');
      }
      state = AsyncValue.data(state.value);
      // Store phone for verification - removed for mock
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyOTP(String otp, String phoneNumber) async {
    state = const AsyncValue.loading();
    try {
      // Mock: Hardcoded OTP '123456'
      if (otp != '123456') {
        throw AuthFailure(message: 'Invalid OTP');
      }
      // Create user
      final user = User(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
        email: '$phoneNumber@example.com', // Mock email
        name: 'User', // Name can be added later
        phone: phoneNumber,
        createdAt: DateTime.now(),
        isVerified: true,
      );
      // Save to repo (mock) - Skip for now due to type conflict, handle in repo later
      // await ref.read(authRepositoryProvider).saveUser(user);
      // Set authenticated
      await SharedPrefsHelper.setAuthenticated(true);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      // Mock logout
      await SharedPrefsHelper.setAuthenticated(false);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Social login stubs
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      // Stub: Print log
      debugPrint('Google sign-in stubbed');
      // Mock success
      final user = User(
        id: 'google_mock_id',
        email: 'google@example.com',
        name: 'Google User',
        createdAt: DateTime.now(),
      );
      await SharedPrefsHelper.setAuthenticated(true);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithFacebook() async {
    state = const AsyncValue.loading();
    try {
      debugPrint('Facebook sign-in stubbed');
      final user = User(
        id: 'fb_mock_id',
        email: 'fb@example.com',
        name: 'Facebook User',
        createdAt: DateTime.now(),
      );
      await SharedPrefsHelper.setAuthenticated(true);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // DISABLED: Apple Sign-in - Not implemented for now
  // Future<void> signInWithApple() async {
  //   state = const AsyncValue.loading();
  //   try {
  //     debugPrint('Apple sign-in stubbed');
  //     final user = User(
  //       id: 'apple_mock_id',
  //       email: 'apple@example.com',
  //       name: 'Apple User',
  //       createdAt: DateTime.now(),
  //     );
  //     await SharedPrefsHelper.setAuthenticated(true);
  //     state = AsyncValue.data(user);
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }

  // DISABLED: Anonymous sign-in - Guest mode not needed right now
  // If you want to enable guest browsing later, uncomment these methods

  // // Anonymous sign-in for guest access
  // Future<void> signInAnonymously() async {
  //   state = const AsyncValue.loading();
  //   try {
  //     final repository = ref.read(authRepositoryProvider);
  //     final user = await repository.signInAnonymously();
  //     await SharedPrefsHelper.setAuthenticated(true);
  //     state = AsyncValue.data(user);
  //     debugPrint(
  //       'Anonymous sign-in successful - user is now browsing as guest',
  //     );
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }

  // // Link anonymous account to email/password
  // Future<void> linkAccountWithEmail(String email, String password) async {
  //   state = const AsyncValue.loading();
  //   try {
  //     final repository = ref.read(authRepositoryProvider);
  //     final user = await repository.linkEmailPassword(email, password);
  //     state = AsyncValue.data(user);
  //     debugPrint('Anonymous account linked to email: $email');
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }

  // // Link anonymous account to phone number
  // Future<void> linkAccountWithPhone(String phoneNumber) async {
  //   state = const AsyncValue.loading();
  //   try {
  //     final repository = ref.read(authRepositoryProvider);
  //     final user = await repository.linkPhone(phoneNumber);
  //     state = AsyncValue.data(user);
  //     debugPrint('Anonymous account linked to phone: $phoneNumber');
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }
}

// Providers
final authProvider = AsyncNotifierProvider<AuthStateNotifier, User?>(
  () => AuthStateNotifier(),
);

final phoneProvider = StateProvider<String>((ref) => '');

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Will be implemented later
  throw UnimplementedError('AuthRepository not implemented yet');
});
