/// Use case for getting restaurants within map bounds (viewport)
import '../../../../core/errors/failures.dart';
import '../entities/location.dart';
import '../../data/repositories/map_repository.dart';
import '../../../home/domain/entities/restaurant.dart';

class GetRestaurantsInBounds {
  const GetRestaurantsInBounds(this._repository);

  final MapRepository _repository;

  /// Execute the use case
  Future<List<Restaurant>> call({
    required Location northeast,
    required Location southwest,
    List<String>? cuisineTypes,
    double? minRating,
    bool? isOpen,
  }) async {
    try {
      final restaurants = await _repository.getRestaurantsInBounds(
        northeast: northeast,
        southwest: southwest,
        cuisineTypes: cuisineTypes,
        minRating: minRating,
        isOpen: isOpen,
      );
      return restaurants;
    } catch (e) {
      throw LocationFailure(message: e.toString());
    }
  }
}