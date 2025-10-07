import "package:logger/logger.dart";
import "../../../../core/services/firebase/firebase_auth_service.dart";
import "../../domain/entities/user.dart";

class FirebaseAuthDataSource {

  FirebaseAuthDataSource(this._authService);
  final FirebaseAuthService _authService;

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  static String? _storedVerificationId;

  Future<void> sendOTP(String phoneNumber) async {
    await _authService.verifyPhoneNumber(
      phoneNumber,
      (verificationId) {
        _storedVerificationId = verificationId;
        Logger().i("OTP sent, verification ID stored: $verificationId");
      },
      (message) => Logger().i("Verification completed: $message"),
      (message) => Logger().e("Verification failed: $message"),
    );
  }

  Future<User> verifyOTP(String otp, String phoneNumber) async {
    if (_storedVerificationId == null) {
      throw Exception("Verification ID not found. Please request OTP first.");
    }
    var credential = await _authService.signInWithPhoneCredential(
      _storedVerificationId!,
      otp,
    );
    var user = _authService.firebaseUserToAppUser(credential.user);
    if (user == null) throw Exception("Failed to create user from credential");
    return user;
  }

  Future<User> signInWithGoogle() async {
    var credential = await _authService.signInWithGoogle();
    var user = _authService.firebaseUserToAppUser(credential?.user);
    if (user == null) throw Exception("Google sign-in failed");
    return user;
  }

  Future<User> signInWithFacebook() async {
    // Facebook sign-in would need facebook_auth package
    // For now, throw not implemented
    throw Exception("Facebook sign-in not implemented");
  }

  // Email/password auth
  Future<User> signInWithEmail(String email, String password) async {
    var credential = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );
    var user = _authService.firebaseUserToAppUser(credential.user);
    if (user == null) throw Exception("Email sign-in failed");
    return user;
  }

  Future<User> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    var credential = await _authService.createUserWithEmailAndPassword(
      email,
      password,
    );
    // Update display name
    await _authService.updateProfile(displayName: name);
    var user = _authService.firebaseUserToAppUser(credential.user);
    if (user == null) throw Exception("Email sign-up failed");
    return user;
  }

  Future<void> logout() async {
    await _authService.signOut();
    Logger().i("User logged out");
  }

  Future<void> sendEmailVerification() async {
    await _authService.sendEmailVerification();
    Logger().i("Email verification sent");
  }

  User? getCurrentUser() => _authService.firebaseUserToAppUser(_authService.currentUser);
}
