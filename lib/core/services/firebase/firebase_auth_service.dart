import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../features/auth/domain/entities/user.dart' as app_user;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn? _googleSignIn;

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      _googleSignIn ??= GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  // Sign in anonymously
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    await _auth.currentUser?.updateDisplayName(displayName);
    await _auth.currentUser?.updatePhotoURL(photoURL);
  }

  // Update email - requires reauthentication
  Future<void> updateEmail(String newEmail) async {
    // Note: Firebase requires recent authentication for email updates
    // This should be handled in the UI with reauthentication
    await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  // Reload user data
  Future<void> reload() async {
    await _auth.currentUser?.reload();
  }

  // Sign out
  Future<void> signOut() async {
    if (_googleSignIn != null) {
      await _googleSignIn!.signOut();
    }
    await _auth.signOut();
  }

  // Delete account
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  // Convert Firebase User to app User
  app_user.User? firebaseUserToAppUser(User? firebaseUser) {
    if (firebaseUser == null) return null;

    return app_user.User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split('@')[0] ??
          'User',
      phone: firebaseUser.phoneNumber,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      isVerified: firebaseUser.emailVerified,
      isAnonymous: firebaseUser.isAnonymous,
    );
  }

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Get user ID token
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  // Verify phone number (for future implementation)
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String) onCodeSent,
    Function(String) onVerificationCompleted,
    Function(String) onVerificationFailed,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        onVerificationCompleted('Verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Sign in with phone credential
  Future<UserCredential> signInWithPhoneCredential(
    String verificationId,
    String smsCode,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }
}
