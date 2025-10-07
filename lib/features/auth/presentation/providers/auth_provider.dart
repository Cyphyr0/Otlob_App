import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../../../core/services/service_locator.dart";
import "../../../../core/utils/shared_prefs_helper.dart";
import "../../data/repositories/firebase_auth_repository.dart";
import "../../domain/entities/user.dart";
import "../../domain/repositories/auth_repository.dart";

class AuthStateNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    var repository = ref.read(authRepositoryProvider);
    var user = repository.getCurrentUser();
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<void> sendOTP(String phoneNumber) async {
    state = const AsyncValue.loading();
    try {
      var repository = ref.read(authRepositoryProvider);
      await repository.sendOTP(phoneNumber);
      state = AsyncValue.data(state.value);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyOTP(String otp, String phoneNumber) async {
    state = const AsyncValue.loading();
    try {
      // Call repository to verify OTP
      var repository = ref.read(authRepositoryProvider);
      var user = await repository.verifyOTP(otp, phoneNumber);

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
      var repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Social login stubs
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      var repository = ref.read(authRepositoryProvider);
      var user = await repository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithFacebook() async {
    state = const AsyncValue.loading();
    try {
      var repository = ref.read(authRepositoryProvider);
      var user = await repository.signInWithFacebook();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // New: Email/password sign-in
  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      var repository = ref.read(authRepositoryProvider);
      var user = await repository.signInWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    try {
      var repository = ref.read(authRepositoryProvider);
      var user = await repository.signUpWithEmail(name, email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
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
  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    try {
      // Use the repository's method if available, otherwise access service directly
      var repository = ref.read(authRepositoryProvider);
      if (repository is FirebaseAuthRepository) {
        // Use a public method for password reset if available
        await (repository as dynamic).sendPasswordResetEmail(email);
      } else {
        throw Exception("Password reset not implemented for this repository");
      }
      state = AsyncValue.data(state.value);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Email verification
  Future<void> sendEmailVerification() async {
    state = const AsyncValue.loading();
    try {
      var repository = ref.read(authRepositoryProvider);
      if (repository is FirebaseAuthRepository) {
        await (repository as dynamic).sendEmailVerification();
      } else {
        throw Exception("Email verification not implemented for this repository");
      }
      state = AsyncValue.data(state.value);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      var repository = ref.read(authRepositoryProvider);
      return repository.getCurrentUser()?.isVerified ?? false;
    } catch (e) {
      return false;
    }
  }
}

// Providers
final authProvider = AsyncNotifierProvider<AuthStateNotifier, User?>(
  AuthStateNotifier.new,
);

final phoneProvider = StateProvider<String>((ref) => "");

final authRepositoryProvider = Provider<AuthRepository>((ref) => getIt<FirebaseAuthRepository>());
