import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../domain/entities/profile.dart';
import 'profile_datasource.dart';

class FirebaseProfileDataSource implements ProfileDataSource {
  final FirebaseFirestoreService _firestoreService;

  FirebaseProfileDataSource(this._firestoreService);

  static const String _collection = 'profiles';

  @override
  Future<Profile> getProfile(String userId) async {
    try {
      final doc = await _firestoreService.firestoreInstance
          .collection(_collection)
          .doc('${userId}_profile')
          .get();

      if (!doc.exists) {
        throw Exception('Profile not found for user: $userId');
      }

      return Profile.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<Profile> createProfile(Profile profile) async {
    try {
      final profileDoc = _firestoreService.firestoreInstance
          .collection(_collection)
          .doc(profile.id);

      // Check if profile already exists
      final existing = await profileDoc.get();
      if (existing.exists) {
        throw Exception('Profile already exists for user: ${profile.userId}');
      }

      // Create the profile document
      await profileDoc.set(profile.toJson());

      return profile;
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    try {
      final profileDoc = _firestoreService.firestoreInstance
          .collection(_collection)
          .doc(profile.id);

      // Check if profile exists
      final existing = await profileDoc.get();
      if (!existing.exists) {
        throw Exception('Profile not found for user: ${profile.userId}');
      }

      // Update the profile document
      await profileDoc.update({
        ...profile.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Return updated profile
      final updatedDoc = await profileDoc.get();
      return Profile.fromJson(updatedDoc.data()!);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    try {
      await _firestoreService.firestoreInstance
          .collection(_collection)
          .doc(profileId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  @override
  Future<bool> profileExists(String userId) async {
    try {
      final doc = await _firestoreService.firestoreInstance
          .collection(_collection)
          .doc('${userId}_profile')
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<Profile?> watchProfile(String userId) {
    return _firestoreService.firestoreInstance
        .collection(_collection)
        .doc('${userId}_profile')
        .snapshots()
        .map((doc) {
          if (!doc.exists || doc.data() == null) {
            return null;
          }
          return Profile.fromJson(doc.data()!);
        });
  }
}
