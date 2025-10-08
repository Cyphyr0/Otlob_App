import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._dataSource);
  final FirebaseAuthDataSource _dataSource;

  // Expose password reset for provider
  Future<void> sendPasswordResetEmail(String email) async {
    await _dataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendOTP(String phoneNumber) async {
    try {
      await _dataSource.sendOTP(phoneNumber);
    } catch (e) {
      throw AuthFailure('Failed to send OTP: $e');
    }
  }

  @override
  Future<User> verifyOTP(String otp, String phoneNumber) async {
    try {
      var user = await _dataSource.verifyOTP(otp, phoneNumber);
      await saveUser(user); // Save after verification
      return user;
    } catch (e) {
      throw AuthFailure('Verification failed: $e');
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      var user = await _dataSource.signInWithGoogle();
      await saveUser(user);
      return user;
    } catch (e) {
      throw AuthFailure('Google sign-in failed: $e');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      var user = await _dataSource.signInWithFacebook();
      await saveUser(user);
      return user;
    } catch (e) {
      throw AuthFailure('Facebook sign-in failed: $e');
    }
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      var user = await _dataSource.signInWithEmail(email, password);
      await saveUser(user);
      return user;
    } catch (e) {
      throw AuthFailure('Email sign-in failed: $e');
    }
  }

  @override
  Future<User> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      var user = await _dataSource.signUpWithEmail(name, email, password);
      await saveUser(user);
      return user;
    } catch (e) {
      throw AuthFailure('Email sign-up failed: $e');
    }
  }

  // DISABLED: Apple Sign-in - Not implemented for now
  // @override
  // Future<User> signInWithApple() async {
  //   try {
  //     final user = await _dataSource.signInWithApple();
  //     await saveUser(user);
  //     return user;
  //   } catch (e) {
  //     throw AuthFailure(message: 'Apple sign-in failed: $e');
  //   }
  // }

  // DISABLED: Anonymous sign-in - Guest mode not needed right now
  // @override
  // Future<User> signInAnonymously() async {
  //   try {
  //     final user = await _dataSource.signInAnonymously();
  //     await saveUser(user);
  //     return user;
  //   } catch (e) {
  //     throw AuthFailure(message: 'Anonymous sign-in failed: $e');
  //   }
  // }

  // @override
  // Future<User> linkEmailPassword(String email, String password) async {
  //   try {
  //     final user = await _dataSource.linkEmailPassword(email, password);
  //     await saveUser(user); // Update saved user data
  //     return user;
  //   } catch (e) {
  //     throw AuthFailure(message: 'Account linking failed: $e');
  //   }
  // }

  // @override
  // Future<User> linkPhone(String phoneNumber) async {
  //   try {
  //     final user = await _dataSource.linkPhone(phoneNumber);
  //     await saveUser(user); // Update saved user data
  //     return user;
  //   } catch (e) {
  //     throw AuthFailure(message: 'Phone linking failed: $e');
  //   }
  // }

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } catch (e) {
      throw AuthFailure('Logout failed: $e');
    }
  }

  @override
  User? getCurrentUser() {
    try {
      return _dataSource.getCurrentUser();
    } catch (e) {
      throw AuthFailure('Failed to get current user: $e');
    }
  }

  @override
  Future<void> saveUser(User user) async {
    // Mock save - in real, use Firestore or Drift
    // For now, print to console
    Logger().i('Mock saving user to local DB: ${user.name} (${user.email})');
    // To avoid type conflict, skip actual DB insert for mock
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _dataSource.sendEmailVerification();
    } catch (e) {
      throw AuthFailure('Failed to send email verification: $e');
    }
  }
}
