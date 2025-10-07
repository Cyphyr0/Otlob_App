import '../entities/user_preferences.dart';

abstract class UserPreferencesRepository {
  Future<UserPreferences?> getUserPreferences(String userId);
  Future<void> saveUserPreferences(UserPreferences preferences);
  Future<void> updateUserPreferences(UserPreferences preferences);
  Future<void> deleteUserPreferences(String userId);
  Future<bool> hasUserPreferences(String userId);
}