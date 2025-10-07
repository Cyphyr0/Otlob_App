import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/home_repository.dart';

class FirebaseHomeRepository implements HomeRepository {

  FirebaseHomeRepository(this._firestoreService);
  final FirebaseFirestoreService _firestoreService;

  @override
  Future<List<Restaurant>> getRestaurants() async => _firestoreService.getRestaurants();

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    if (query.isEmpty) {
      return getRestaurants();
    }
    return _firestoreService.searchRestaurants(query);
  }

  @override
  Future<List<Restaurant>> getHiddenGems() async {
    // Restaurants with high rating but lower tawseya count (less discovered)
    return _firestoreService.getRestaurants(minRating: 4.5, limit: 10);
  }

  @override
  Future<List<Restaurant>> getLocalHeroes() async {
    // Restaurants with high tawseya count (community favorites)
    return _firestoreService.getRestaurants(
      limit: 10,
      sortBy: 'tawseyaCount',
    );
  }

  @override
  Future<List<Restaurant>> getRestaurantsPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    var startAfter = page > 1
        ? null
        : null; // Would need to track last document
    return _firestoreService.getRestaurants(
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
      return getRestaurantsPaginated(page: page, limit: limit);
    }

    var startAfter = page > 1
        ? null
        : null; // Would need to track last document
    return _firestoreService.searchRestaurants(
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
