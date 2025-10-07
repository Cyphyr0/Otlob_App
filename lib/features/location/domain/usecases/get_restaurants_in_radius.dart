/// Use case for getting restaurants within a specific radius from a location
library;
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/restaurant.dart';
import '../../data/repositories/map_repository.dart';
import '../entities/location.dart';

/// Use case for getting restaurants within a specific radius
class GetRestaurantsInRadius {
  const GetRestaurantsInRadius(this._repository);

  final MapRepository _repository;

  /// Execute the use case
  Future<List<Restaurant>> call({
    required Location center,
    required double radiusKm,
    List<String>? cuisineTypes,
    double? minRating,
    bool? isOpen,
  }) async {
    try {
      final restaurants = await _repository.getRestaurantsInRadius(
        center: center,
        radiusKm: radiusKm,
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

/// Use case for getting restaurants within map bounds (viewport)
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

/// Use case for searching restaurants by location
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

/// Use case for getting nearby restaurants with delivery
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

/// Use case for checking if location is in delivery area
class CheckLocationInDeliveryArea {
  const CheckLocationInDeliveryArea(this._repository);

  final MapRepository _repository;

  /// Execute the use case
  Future<bool> call({
    required Location location,
    required String restaurantId,
  }) async {
    try {
      final isInArea = await _repository.isLocationInDeliveryArea(
        location: location,
        restaurantId: restaurantId,
      );
      return isInArea;
    } catch (e) {
      throw LocationFailure(message: e.toString());
    }
  }
}

/// Use case for getting restaurant delivery areas
class GetRestaurantDeliveryAreas {
  const GetRestaurantDeliveryAreas(this._repository);

  final MapRepository _repository;

  /// Execute the use case
  Future<List<DeliveryArea>> call(String restaurantId) async {
    try {
      final deliveryAreas = await _repository.getRestaurantDeliveryAreas(restaurantId);
      return deliveryAreas;
    } catch (e) {
      throw LocationFailure(message: e.toString());
    }
  }
}

/// Custom failure for location-related errors
class LocationFailure extends Failure {
  const LocationFailure({required super.message});

  @override
  List<Object?> get props => [message];
}