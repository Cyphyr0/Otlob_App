import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasource.dart';

class FirebaseProfileRepository implements ProfileRepository {

  FirebaseProfileRepository(this._dataSource);
  final ProfileDataSource _dataSource;

  @override
  Future<Profile> getProfile(String userId) async => _dataSource.getProfile(userId);

  @override
  Future<Profile> createProfile(Profile profile) async => _dataSource.createProfile(profile);

  @override
  Future<Profile> updateProfile(Profile profile) async => _dataSource.updateProfile(profile);

  @override
  Future<void> deleteProfile(String profileId) async => _dataSource.deleteProfile(profileId);

  @override
  Future<bool> profileExists(String userId) async => _dataSource.profileExists(userId);

  @override
  Stream<Profile?> watchProfile(String userId) => _dataSource.watchProfile(userId);
}