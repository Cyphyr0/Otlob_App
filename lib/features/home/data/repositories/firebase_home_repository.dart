import 'package:otlob_app/core/services/firebase/firebase_firestore_service.dart';
import 'package:otlob_app/features/home/domain/entities/restaurant.dart';
import 'package:otlob_app/features/home/domain/repositories/home_repository.dart';

class FirebaseHomeRepository implements HomeRepository {
  final FirebaseFirestoreService _firestoreService;

  FirebaseHomeRepository(this._firestoreService);

  @override
  Future<List<Restaurant>> getRestaurants() async {
    return await _firestoreService.getRestaurants();
  }

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    if (query.isEmpty) {
      return await getRestaurants();
    }
    return await _firestoreService.searchRestaurants(query);
  }

  @override
  Future<List<Restaurant>> getHiddenGems() async {
    // Restaurants with high rating but lower tawseya count (less discovered)
    return await _firestoreService.getRestaurants(minRating: 4.5, limit: 10);
  }

  @override
  Future<List<Restaurant>> getLocalHeroes() async {
    // Restaurants with high tawseya count (community favorites)
    return await _firestoreService.getRestaurants(
      limit: 10,
      sortBy: 'tawseyaCount',
    );
  }

  @override
  Future<List<Restaurant>> getRestaurantsPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    final startAfter = page > 1
        ? null
        : null; // Would need to track last document
    return await _firestoreService.getRestaurants(
      limit: limit,
      startAfter: startAfter,
    );
  }

  @override
  Future<List<Restaurant>> searchRestaurantsPaginated(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    if (query.isEmpty) {
      return await getRestaurantsPaginated(page: page, limit: limit);
    }

    final startAfter = page > 1
        ? null
        : null; // Would need to track last document
    return await _firestoreService.searchRestaurants(
      query,
      limit: limit,
      startAfter: startAfter,
    );
  }

  @override
  Future<void> toggleFavorite(String restaurantId) async {
    // This would need the current user ID from auth service
    // For now, this is a placeholder
    // final userId = await _authService.getCurrentUserId();
    // final isFavorite = await _firestoreService.isFavorite(userId, restaurantId);
    // if (isFavorite) {
    //   await _firestoreService.removeFromFavorites(userId, restaurantId);
    // } else {
    //   await _firestoreService.addToFavorites(userId, restaurantId);
    // }
  }
}
