import 'package:otlob_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<void> sendOTP(String phoneNumber);
  Future<User> verifyOTP(String otp, String phoneNumber);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithApple();
  Future<User> signInAnonymously(); // Anonymous/Guest sign-in
  Future<User> linkEmailPassword(String email, String password); // Link anonymous to email
  Future<User> linkPhone(String phoneNumber); // Link anonymous to phone
  Future<void> logout();
  User? getCurrentUser();
  Future<void> saveUser(User user);
}
