/// Repository interface for delivery area validation operations
library;
import '../../../../features/home/domain/entities/restaurant.dart';
import '../../../../features/location/domain/entities/location.dart';
import '../../domain/entities/delivery_area_status.dart';

abstract class DeliveryAreaRepository {
  /// Check if a location is within a restaurant's delivery area
  Future<bool> isLocationInDeliveryArea({
    required Location location,
    required String restaurantId,
  });

  /// Get delivery areas for a specific restaurant
  Future<List<DeliveryArea>> getRestaurantDeliveryAreas(String restaurantId);

  /// Get all restaurants that deliver to a specific location
  Future<List<Restaurant>> getRestaurantsDeliveringToLocation({
    required Location location,
    double? maxDistance,
  });

  /// Get delivery area status for a restaurant and user location
  Future<DeliveryAreaStatus> getDeliveryAreaStatus({
    required Location userLocation,
    required String restaurantId,
  });

  /// Calculate distance between user location and restaurant
  Future<double> calculateDistanceToRestaurant({
    required Location userLocation,
    required String restaurantId,
  });

  /// Calculate delivery fee based on distance and restaurant
  Future<double> calculateDeliveryFee({
    required Location userLocation,
    required String restaurantId,
  });

  /// Get estimated delivery time for a restaurant order
  Future<int> getEstimatedDeliveryTime({
    required Location userLocation,
    required String restaurantId,
  });

  /// Cache delivery area validation result for performance
  Future<void> cacheValidationResult({
    required String restaurantId,
    required Location userLocation,
    required DeliveryAreaStatus status,
    required DateTime timestamp,
  });

  /// Get cached validation result if still valid
  Future<DeliveryAreaStatus?> getCachedValidationResult({
    required String restaurantId,
    required Location userLocation,
  });
}