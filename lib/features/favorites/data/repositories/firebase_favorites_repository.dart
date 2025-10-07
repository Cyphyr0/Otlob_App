import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorites_repository.dart';

class FirebaseFavoritesRepository implements FavoritesRepository {

  FirebaseFavoritesRepository(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _favoritesCollection =>
      _firestore.collection('favorites');

  @override
  Future<List<Favorite>> getFavorites() async {
    if (_userId.isEmpty) return [];

    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Favorite.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  @override
  Future<void> addFavorite(String restaurantId, String restaurantName, String? restaurantImageUrl) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      final docRef = _favoritesCollection.doc();
      final favorite = Favorite(
        id: docRef.id,
        userId: _userId,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        restaurantImageUrl: restaurantImageUrl,
        createdAt: DateTime.now(),
      );

      await docRef.set(favorite.toJson());
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String restaurantId) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(String restaurantId) async {
    if (_userId.isEmpty) return false;

    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .where('restaurantId', isEqualTo: restaurantId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> toggleFavorite(String restaurantId, String restaurantName, String? restaurantImageUrl) async {
    final isFav = await isFavorite(restaurantId);
    if (isFav) {
      await removeFavorite(restaurantId);
      return false;
    } else {
      await addFavorite(restaurantId, restaurantName, restaurantImageUrl);
      return true;
    }
  }

  @override
  Future<void> clearFavorites() async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }

  @override
  Stream<List<Favorite>> watchFavorites() {
    if (_userId.isEmpty) return Stream.value([]);

    return _favoritesCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
              .map((doc) => Favorite.fromJson({'id': doc.id, ...doc.data()}))
              .toList())
        .handleError((error) {
          throw Exception('Failed to watch favorites: $error');
        });
  }
}