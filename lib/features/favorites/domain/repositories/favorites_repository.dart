import '../entities/favorite.dart';

abstract class FavoritesRepository {
  /// Get all favorites for the current user
  Future<List<Favorite>> getFavorites();

  /// Add a restaurant to favorites
  Future<void> addFavorite(String restaurantId, String restaurantName, String? restaurantImageUrl);

  /// Remove a restaurant from favorites
  Future<void> removeFavorite(String restaurantId);

  /// Check if a restaurant is in favorites
  Future<bool> isFavorite(String restaurantId);

  /// Toggle favorite status for a restaurant
  Future<bool> toggleFavorite(String restaurantId, String restaurantName, String? restaurantImageUrl);

  /// Clear all favorites for the current user
  Future<void> clearFavorites();

  /// Get favorites as a stream for real-time updates
  Stream<List<Favorite>> watchFavorites();
}