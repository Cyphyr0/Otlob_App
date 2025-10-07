import "../entities/restaurant.dart";

abstract class HomeRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<List<Restaurant>> searchRestaurants(String query);
  Future<List<Restaurant>> getHiddenGems();
  Future<List<Restaurant>> getLocalHeroes();
  Future<List<Restaurant>> getRestaurantsPaginated({
    int page = 1,
    int limit = 20,
  });
  Future<List<Restaurant>> searchRestaurantsPaginated(
    String query, {
    int page = 1,
    int limit = 20,
  });
  Future<void> toggleFavorite(String restaurantId);
}
