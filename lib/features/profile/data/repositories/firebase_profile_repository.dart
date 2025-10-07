import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasource.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final ProfileDataSource _dataSource;

  FirebaseProfileRepository(this._dataSource);

  @override
  Future<Profile> getProfile(String userId) async {
    return _dataSource.getProfile(userId);
  }

  @override
  Future<Profile> createProfile(Profile profile) async {
    return _dataSource.createProfile(profile);
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    return _dataSource.updateProfile(profile);
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    return _dataSource.deleteProfile(profileId);
  }

  @override
  Future<bool> profileExists(String userId) async {
    return _dataSource.profileExists(userId);
  }

  @override
  Stream<Profile?> watchProfile(String userId) {
    return _dataSource.watchProfile(userId);
  }
}