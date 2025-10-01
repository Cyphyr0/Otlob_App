import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logger/logger.dart';
import 'package:otlob_app/features/auth/domain/entities/user.dart';

class FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Future<void> sendOTP(String phoneNumber) async {
    // Mock implementation - simulate sending OTP
    await Future.delayed(const Duration(seconds: 1));
    Logger().i('Mock OTP sent to $phoneNumber. Use code: 123456');
  }

  Future<User> verifyOTP(String otp, String phoneNumber) async {
    // Mock verification - hardcoded OTP
    if (otp != '123456') {
      throw Exception('Invalid OTP');
    }
    // Create mock user
    return User(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      email: '$phoneNumber@example.com',
      name: 'New User',
      phone: phoneNumber,
      createdAt: DateTime.now(),
      isVerified: true,
    );
  }

  Future<User> signInWithGoogle() async {
    // Stub - print log, return mock user
    Logger().i(
      'Google sign-in stubbed - would integrate with GoogleSignIn and Firebase',
    );
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    return User(
      id: 'google_mock_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@gmail.com',
      name: 'Google User',
      createdAt: DateTime.now(),
      isVerified: true,
    );
  }

  Future<User> signInWithFacebook() async {
    // Stub - print log, return mock user
    Logger().i(
      'Facebook sign-in stubbed - would integrate with Facebook Auth and Firebase',
    );
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: 'fb_mock_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@fb.com',
      name: 'Facebook User',
      createdAt: DateTime.now(),
      isVerified: true,
    );
  }

  Future<User> signInWithApple() async {
    // Stub - print log, return mock user
    Logger().i(
      'Apple sign-in stubbed - would integrate with SignInWithApple and Firebase',
    );
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: 'apple_mock_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@apple.com',
      name: 'Apple User',
      createdAt: DateTime.now(),
      isVerified: true,
    );
  }

  Future<void> logout() async {
    // Real Firebase logout
    await _auth.signOut();
    Logger().i('User logged out');
  }

  User? getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      return User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        phone: user.phoneNumber,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        isVerified: user.emailVerified,
      );
    }
    return null;
  }
}
