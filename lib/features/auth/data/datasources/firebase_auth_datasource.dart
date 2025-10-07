import 'package:logger/logger.dart';
import 'package:otlob_app/core/services/firebase/firebase_auth_service.dart';
import 'package:otlob_app/features/auth/domain/entities/user.dart';

class FirebaseAuthDataSource {
  final FirebaseAuthService _authService;

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  FirebaseAuthDataSource(this._authService);

  Future<void> sendOTP(String phoneNumber) async {
    await _authService.verifyPhoneNumber(
      phoneNumber,
      (verificationId) =>
          Logger().i('OTP sent, verification ID: $verificationId'),
      (message) => Logger().i('Verification completed: $message'),
      (message) => Logger().e('Verification failed: $message'),
    );
  }

  Future<User> verifyOTP(String otp, String phoneNumber) async {
    final verificationId =
        'stored_verification_id'; // This should be stored from sendOTP
    final credential = await _authService.signInWithPhoneCredential(
      verificationId,
      otp,
    );
    final user = _authService.firebaseUserToAppUser(credential.user);
    if (user == null) throw Exception('Failed to create user from credential');
    return user;
  }

  Future<User> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    final user = _authService.firebaseUserToAppUser(credential?.user);
    if (user == null) throw Exception('Google sign-in failed');
    return user;
  }

  Future<User> signInWithFacebook() async {
    // Facebook sign-in would need facebook_auth package
    // For now, throw not implemented
    throw Exception('Facebook sign-in not implemented');
  }

  // Email/password auth
  Future<User> signInWithEmail(String email, String password) async {
    final credential = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );
    final user = _authService.firebaseUserToAppUser(credential.user);
    if (user == null) throw Exception('Email sign-in failed');
    return user;
  }

  Future<User> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    final credential = await _authService.createUserWithEmailAndPassword(
      email,
      password,
    );
    // Update display name
    await _authService.updateProfile(displayName: name);
    final user = _authService.firebaseUserToAppUser(credential.user);
    if (user == null) throw Exception('Email sign-up failed');
    return user;
  }

  Future<void> logout() async {
    await _authService.signOut();
    Logger().i('User logged out');
  }

  User? getCurrentUser() {
    return _authService.firebaseUserToAppUser(_authService.currentUser);
  }
}
