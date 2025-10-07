/// Core service for delivery area validation business logic
import 'dart:async';

import '../../../../core/errors/failures.dart';
import '../../../../features/location/domain/entities/location.dart';
import '../../../../features/home/domain/entities/restaurant.dart';
import '../entities/delivery_area_status.dart';
import '../entities/delivery_area_validation.dart';
import '../repositories/delivery_area_repository.dart';

class DeliveryAreaValidationService {
  const DeliveryAreaValidationService(this._repository);

  final DeliveryAreaRepository _repository;

  /// Validate user location for a specific restaurant
  Future<DeliveryAreaValidation> validateUserLocation({
    required Location userLocation,
    required Restaurant restaurant,
  }) async {
    try {
      // Check if location is within delivery area
      final isWithinArea = await _repository.isLocationInDeliveryArea(
        location: userLocation,
        restaurantId: restaurant.id,
      );

      if (isWithinArea) {
        // Calculate additional details for within-area validation
        final distance = await _repository.calculateDistanceToRestaurant(
          userLocation: userLocation,
          restaurantId: restaurant.id,
        );

        final deliveryFee = await _repository.calculateDeliveryFee(
          userLocation: userLocation,
          restaurantId: restaurant.id,
        );

        final deliveryTime = await _repository.getEstimatedDeliveryTime(
          userLocation: userLocation,
          restaurantId: restaurant.id,
        );

        return DeliveryAreaValidation.withinArea(
          restaurant: restaurant,
          userLocation: userLocation,
          distance: distance,
          deliveryFee: deliveryFee,
          estimatedDeliveryTime: deliveryTime,
        );
      } else {
        // User is outside delivery area
        final distance = await _repository.calculateDistanceToRestaurant(
          userLocation: userLocation,
          restaurantId: restaurant.id,
        );

        return DeliveryAreaValidation.outsideArea(
          restaurant: restaurant,
          userLocation: userLocation,
          distance: distance,
        );
      }
    } catch (e) {
      return DeliveryAreaValidation.error(
        restaurant: restaurant,
        message: 'Validation failed: $e',
      );
    }
  }

  /// Validate multiple restaurants for a user location
  Future<List<DeliveryAreaValidation>> validateMultipleRestaurants({
    required Location userLocation,
    required List<Restaurant> restaurants,
  }) async {
    final validations = <DeliveryAreaValidation>[];

    for (final restaurant in restaurants) {
      try {
        final validation = await validateUserLocation(
          userLocation: userLocation,
          restaurant: restaurant,
        );
        validations.add(validation);
      } catch (e) {
        // Add error validation for failed restaurant
        validations.add(
          DeliveryAreaValidation.error(
            restaurant: restaurant,
            message: 'Failed to validate: $e',
          ),
        );
      }
    }

    return validations;
  }

  /// Get restaurants that deliver to a specific location
  Future<List<Restaurant>> getAvailableRestaurants({
    required Location userLocation,
    List<Restaurant>? allRestaurants,
    double? maxDistance,
  }) async {
    try {
      return await _repository.getRestaurantsDeliveringToLocation(
        location: userLocation,
        maxDistance: maxDistance,
      );
    } catch (e) {
      // Fallback to filtering from provided list if repository fails
      if (allRestaurants != null) {
        final validations = await validateMultipleRestaurants(
          userLocation: userLocation,
          restaurants: allRestaurants,
        );

        return validations
            .where((validation) => validation.canOrder)
            .map((validation) => validation.restaurant)
            .toList();
      }

      throw const ValidationFailure(message: 'Failed to get available restaurants');
    }
  }

  /// Check if user can order from any of the provided restaurants
  Future<bool> canOrderFromAnyRestaurant({
    required Location userLocation,
    required List<Restaurant> restaurants,
  }) async {
    try {
      final validations = await validateMultipleRestaurants(
        userLocation: userLocation,
        restaurants: restaurants,
      );

      return validations.any((validation) => validation.canOrder);
    } catch (e) {
      return false;
    }
  }

  /// Get the best restaurant option for user location (closest, fastest, etc.)
  Future<DeliveryAreaValidation?> getBestRestaurantOption({
    required Location userLocation,
    required List<Restaurant> restaurants,
  }) async {
    try {
      final validations = await validateMultipleRestaurants(
        userLocation: userLocation,
        restaurants: restaurants,
      );

      // Filter only restaurants that can deliver
      final availableValidations = validations
          .where((validation) => validation.canOrder)
          .toList();

      if (availableValidations.isEmpty) return null;

      // Sort by total score (distance + delivery time + rating)
      availableValidations.sort((a, b) {
        final scoreA = _calculateRestaurantScore(a);
        final scoreB = _calculateRestaurantScore(b);
        return scoreA.compareTo(scoreB);
      });

      return availableValidations.first;
    } catch (e) {
      return null;
    }
  }

  /// Calculate a score for restaurant selection (lower is better)
  double _calculateRestaurantScore(DeliveryAreaValidation validation) {
    var score = 0.0;

    // Distance factor (closer is better)
    if (validation.distance != null) {
      score += validation.distance! * 2; // Weight distance heavily
    }

    // Delivery time factor (faster is better)
    if (validation.estimatedDeliveryTime != null) {
      score += validation.estimatedDeliveryTime! * 0.5;
    }

    // Rating factor (higher rating is better, so subtract)
    score -= validation.restaurant.rating * 3;

    // Delivery fee factor (lower fee is better)
    if (validation.deliveryFee != null) {
      score += validation.deliveryFee! * 0.1;
    }

    return score;
  }

  /// Stream of validation updates for real-time location changes
  Stream<DeliveryAreaValidation> validationStream({
    required Location userLocation,
    required Restaurant restaurant,
  }) {
    return Stream.periodic(
      const Duration(seconds: 5),
      (_) => validateUserLocation(
        userLocation: userLocation,
        restaurant: restaurant,
      ),
    ).asyncMap((future) => future);
  }
}