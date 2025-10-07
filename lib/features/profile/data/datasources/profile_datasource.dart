import '../../domain/entities/profile.dart';

abstract class ProfileDataSource {
  Future<Profile> getProfile(String userId);
  Future<Profile> createProfile(Profile profile);
  Future<Profile> updateProfile(Profile profile);
  Future<void> deleteProfile(String profileId);
  Future<bool> profileExists(String userId);
  Stream<Profile?> watchProfile(String userId);
}