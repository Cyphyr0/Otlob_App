/// Use case for validating if a user's location is within a restaurant's delivery area
library;
import '../../../../features/home/domain/entities/restaurant.dart';
import '../../../../features/location/domain/entities/location.dart';
import '../entities/delivery_area_status.dart';
import '../entities/delivery_area_validation.dart';
import '../repositories/delivery_area_repository.dart';

class ValidateUserLocation {
  const ValidateUserLocation(this._repository);

  final DeliveryAreaRepository _repository;

  /// Execute the use case
  Future<DeliveryAreaValidation> call({
    required Location userLocation,
    required Restaurant restaurant,
  }) async {
    try {
      // Get delivery area status
      final status = await _repository.getDeliveryAreaStatus(
        userLocation: userLocation,
        restaurantId: restaurant.id,
      );

      // Calculate distance
      final distance = await _repository.calculateDistanceToRestaurant(
        userLocation: userLocation,
        restaurantId: restaurant.id,
      );

      // Calculate delivery fee if within area
      double? deliveryFee;
      int? estimatedDeliveryTime;
      if (status == DeliveryAreaStatus.withinArea) {
        deliveryFee = await _repository.calculateDeliveryFee(
          userLocation: userLocation,
          restaurantId: restaurant.id,
        );
        estimatedDeliveryTime = await _repository.getEstimatedDeliveryTime(
          userLocation: userLocation,
          restaurantId: restaurant.id,
        );
      }

      // Create validation result based on status
      switch (status) {
        case DeliveryAreaStatus.withinArea:
          return DeliveryAreaValidation.withinArea(
            restaurant: restaurant,
            userLocation: userLocation,
            distance: distance,
            deliveryFee: deliveryFee,
            estimatedDeliveryTime: estimatedDeliveryTime,
          );

        case DeliveryAreaStatus.outsideArea:
          return DeliveryAreaValidation.outsideArea(
            restaurant: restaurant,
            userLocation: userLocation,
            distance: distance,
          );

        case DeliveryAreaStatus.permissionDenied:
          return DeliveryAreaValidation.permissionDenied(
            restaurant: restaurant,
          );

        case DeliveryAreaStatus.locationDisabled:
          return DeliveryAreaValidation.locationDisabled(
            restaurant: restaurant,
          );

        case DeliveryAreaStatus.determining:
          return DeliveryAreaValidation.determining(
            restaurant: restaurant,
          );

        case DeliveryAreaStatus.error:
          return DeliveryAreaValidation.error(
            restaurant: restaurant,
            message: 'Unable to validate delivery area',
          );
      }
    } catch (e) {
      return DeliveryAreaValidation.error(
        restaurant: restaurant,
        message: 'Error validating location: $e',
      );
    }
  }
}