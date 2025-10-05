import 'package:otlob_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<void> sendOTP(String phoneNumber);
  Future<User> verifyOTP(String otp, String phoneNumber);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  // Email/password auth
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String name, String email, String password);

  // DISABLED: Apple Sign-in not implemented for now
  // Future<User> signInWithApple();

  // DISABLED: Anonymous/Guest sign-in - optional feature, not needed right now
  // Future<User> signInAnonymously();
  // Future<User> linkEmailPassword(String email, String password); // Link anonymous to email
  // Future<User> linkPhone(String phoneNumber); // Link anonymous to phone

  Future<void> logout();
  User? getCurrentUser();
  Future<void> saveUser(User user);
}
