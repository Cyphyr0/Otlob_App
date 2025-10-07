/// Use case for getting nearby restaurants with delivery
library;
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/restaurant.dart';
import '../../data/repositories/map_repository.dart';
import '../entities/location.dart';

class GetNearbyRestaurantsWithDelivery {
  const GetNearbyRestaurantsWithDelivery(this._repository);

  final MapRepository _repository;

  /// Execute the use case
  Future<List<Restaurant>> call({
    required Location userLocation,
    double? maxDistanceKm,
  }) async {
    try {
      final restaurants = await _repository.getNearbyRestaurantsWithDelivery(
        userLocation: userLocation,
        maxDistanceKm: maxDistanceKm,
      );
      return restaurants;
    } catch (e) {
      throw LocationFailure(message: e.toString());
    }
  }
}