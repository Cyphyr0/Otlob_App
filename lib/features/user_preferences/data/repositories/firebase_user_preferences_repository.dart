import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../../../../core/services/firebase/firebase_firestore_service.dart';

class FirebaseUserPreferencesRepository implements UserPreferencesRepository {
  final FirebaseFirestoreService _firestoreService;

  const FirebaseUserPreferencesRepository(this._firestoreService);

  @override
  Future<UserPreferences?> getUserPreferences(String userId) async {
    try {
      final doc = await _firestoreService.getDocument('user_preferences/$userId');
      if (doc.exists && doc.data() != null) {
        return UserPreferences.fromJson(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user preferences: $e');
    }
  }

  @override
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    try {
      await _firestoreService.setDocument(
        'user_preferences/${preferences.userId}',
        preferences.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to save user preferences: $e');
    }
  }

  @override
  Future<void> updateUserPreferences(UserPreferences preferences) async {
    try {
      final updatedPreferences = preferences.copyWith(
        lastUpdated: DateTime.now(),
      );
      await _firestoreService.updateDocument(
        'user_preferences/${preferences.userId}',
        updatedPreferences.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update user preferences: $e');
    }
  }

  @override
  Future<void> deleteUserPreferences(String userId) async {
    try {
      await _firestoreService.deleteDocument('user_preferences/$userId');
    } catch (e) {
      throw Exception('Failed to delete user preferences: $e');
    }
  }

  @override
  Future<bool> hasUserPreferences(String userId) async {
    try {
      final preferences = await getUserPreferences(userId);
      return preferences != null && preferences.hasPreferences;
    } catch (e) {
      return false;
    }
  }
}