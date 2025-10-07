import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  const ToggleFavorite(this.repository);

  final FavoritesRepository repository;

  Future<bool> call(String restaurantId, String restaurantName, String? restaurantImageUrl) async => repository.toggleFavorite(restaurantId, restaurantName, restaurantImageUrl);
}