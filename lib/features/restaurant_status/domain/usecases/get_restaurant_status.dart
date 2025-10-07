import '../entities/restaurant_status.dart';
import '../repositories/restaurant_status_repository.dart';

class GetRestaurantStatus {
  const GetRestaurantStatus(this._repository);

  final RestaurantStatusRepository _repository;

  Future<RestaurantStatus> call(String restaurantId) => _repository.getRestaurantStatus(restaurantId);
}