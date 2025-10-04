import 'package:logger/logger.dart';
import 'package:otlob_app/core/errors/failures.dart';
import 'package:otlob_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:otlob_app/features/auth/domain/entities/user.dart';
import 'package:otlob_app/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  FirebaseAuthRepository(this._dataSource);

  @override
  Future<void> sendOTP(String phoneNumber) async {
    try {
      await _dataSource.sendOTP(phoneNumber);
    } catch (e) {
      throw AuthFailure(message: 'Failed to send OTP: $e');
    }
  }

  @override
  Future<User> verifyOTP(String otp, String phoneNumber) async {
    try {
      final user = await _dataSource.verifyOTP(otp, phoneNumber);
      await saveUser(user); // Save after verification
      return user;
    } catch (e) {
      throw AuthFailure(message: 'Verification failed: $e');
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final user = await _dataSource.signInWithGoogle();
      await saveUser(user);
      return user;
    } catch (e) {
      throw AuthFailure(message: 'Google sign-in failed: $e');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      final user = await _dataSource.signInWithFacebook();
      await saveUser(user);
      return user;
    } catch (e) {
      throw AuthFailure(message: 'Facebook sign-in failed: $e');
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
      throw AuthFailure(message: 'Logout failed: $e');
    }
  }

  @override
  User? getCurrentUser() {
    try {
      return _dataSource.getCurrentUser();
    } catch (e) {
      throw AuthFailure(message: 'Failed to get current user: $e');
    }
  }

  @override
  Future<void> saveUser(User user) async {
    // Mock save - in real, use Firestore or Drift
    // For now, print to console
    Logger().i('Mock saving user to local DB: ${user.name} (${user.email})');
    // To avoid type conflict, skip actual DB insert for mock
  }
}
