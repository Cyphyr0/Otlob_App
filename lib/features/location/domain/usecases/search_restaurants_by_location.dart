/// Use case for searching restaurants by location
import '../../../../core/errors/failures.dart';
import '../entities/location.dart';
import '../../data/repositories/map_repository.dart';
import '../../../home/domain/entities/restaurant.dart';

class SearchRestaurantsByLocation {
  const SearchRestaurantsByLocation(this._repository);

  final MapRepository _repository;

  /// Execute the use case
  Future<List<Restaurant>> call({
    required String query,
    Location? nearLocation,
    double? radiusKm,
  }) async {
    try {
      final restaurants = await _repository.searchRestaurantsByLocation(
        query: query,
        nearLocation: nearLocation,
        radiusKm: radiusKm,
      );
      return restaurants;
    } catch (e) {
      throw LocationFailure(message: e.toString());
    }
  }
}