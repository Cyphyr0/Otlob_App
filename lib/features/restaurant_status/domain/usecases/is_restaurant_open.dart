import '../repositories/restaurant_status_repository.dart';

class IsRestaurantOpen {
  const IsRestaurantOpen(this._repository);

  final RestaurantStatusRepository _repository;

  Future<bool> call(String restaurantId) => _repository.isRestaurantOpen(restaurantId);
}