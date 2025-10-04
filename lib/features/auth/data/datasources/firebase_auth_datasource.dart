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

  /// Sign in anonymously - allows guest access
  Future<User> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      final firebaseUser = credential.user!;
      
      Logger().i('Anonymous sign-in successful: ${firebaseUser.uid}');
      
      return User(
        id: firebaseUser.uid,
        email: '', // No email for anonymous users
        name: 'Guest', // Default name
        createdAt: DateTime.now(),
        isVerified: false,
        isAnonymous: true, // Mark as anonymous
      );
    } catch (e) {
      Logger().e('Anonymous sign-in failed: $e');
      throw Exception('Anonymous sign-in failed: $e');
    }
  }

  /// Link anonymous account to email/password
  Future<User> linkEmailPassword(String email, String password) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        throw Exception('No anonymous user to link or user is not anonymous');
      }
      
      // Create email/password credential
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      
      // Link the anonymous account to the email/password credential
      final linkedCredential = await currentUser.linkWithCredential(credential);
      final linkedUser = linkedCredential.user!;
      
      Logger().i('Account linked successfully: ${linkedUser.email}');
      
      return User(
        id: linkedUser.uid, // Same ID, now permanent
        email: email,
        name: linkedUser.displayName ?? 'User',
        phone: linkedUser.phoneNumber,
        createdAt: currentUser.metadata.creationTime ?? DateTime.now(),
        isVerified: linkedUser.emailVerified,
        isAnonymous: false, // No longer anonymous
      );
    } catch (e) {
      Logger().e('Account linking failed: $e');
      throw Exception('Account linking failed: $e');
    }
  }

  /// Link anonymous account to phone number
  Future<User> linkPhone(String phoneNumber) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        throw Exception('No anonymous user to link or user is not anonymous');
      }
      
      // Note: This requires phone verification flow with OTP
      // For now, this is a placeholder
      Logger().i('Phone linking stubbed - requires OTP flow');
      
      // Return updated user (in real implementation, this would happen after OTP verification)
      return User(
        id: currentUser.uid,
        email: '',
        name: 'User',
        phone: phoneNumber,
        createdAt: currentUser.metadata.creationTime ?? DateTime.now(),
        isVerified: true,
        isAnonymous: false,
      );
    } catch (e) {
      Logger().e('Phone linking failed: $e');
      throw Exception('Phone linking failed: $e');
    }
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
        name: user.displayName ?? (user.isAnonymous ? 'Guest' : 'User'),
        phone: user.phoneNumber,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        isVerified: user.emailVerified,
        isAnonymous: user.isAnonymous, // Check Firebase's isAnonymous flag
      );
    }
    return null;
  }
}
