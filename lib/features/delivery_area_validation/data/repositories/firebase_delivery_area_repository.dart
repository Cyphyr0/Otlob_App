/// Firebase implementation of delivery area repository
library;
import 'dart:math';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../../../features/home/domain/entities/restaurant.dart';
import '../../../../features/location/domain/entities/location.dart';
import '../../domain/entities/delivery_area_status.dart';
import '../../domain/repositories/delivery_area_repository.dart';

class FirebaseDeliveryAreaRepository implements DeliveryAreaRepository {
  const FirebaseDeliveryAreaRepository(this._firestoreService);

  final FirebaseFirestoreService _firestoreService;

  @override
  Future<bool> isLocationInDeliveryArea({
    required Location location,
    required String restaurantId,
  }) async {
    try {
      // Get restaurant details
      final restaurant = await _getRestaurantById(restaurantId);
      if (restaurant == null) {
        throw const ValidationFailure('Restaurant not found');
      }

      // Calculate distance between user location and restaurant
      final distance = _calculateDistance(
        location.latitude,
        location.longitude,
        restaurant.latitude,
        restaurant.longitude,
      );

      // Check if distance is within delivery radius
      return distance <= restaurant.deliveryRadius;
    } catch (e) {
      if (e is ValidationFailure) rethrow;
      throw ValidationFailure('Failed to check delivery area: $e');
    }
  }

  @override
  Future<List<DeliveryArea>> getRestaurantDeliveryAreas(String restaurantId) async {
    try {
      final restaurant = await _getRestaurantById(restaurantId);
      if (restaurant == null) {
        throw const ValidationFailure('Restaurant not found');
      }

      // For now, return a single circular delivery area around the restaurant
      // In a real implementation, this could be multiple polygons or complex shapes
      return [
        DeliveryArea(
          center: Location(
            latitude: restaurant.latitude,
            longitude: restaurant.longitude,
            address: restaurant.address,
          ),
          radius: restaurant.deliveryRadius,
          name: 'Primary Delivery Area',
          description: 'Main delivery coverage area',
        ),
      ];
    } catch (e) {
      throw ValidationFailure('Failed to get delivery areas: $e');
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsDeliveringToLocation({
    required Location location,
    double? maxDistance,
  }) async {
    try {
      // Get all restaurants
      final restaurants = await _getAllRestaurants();

      // Filter restaurants that deliver to the location
      return restaurants.where((restaurant) {
        final distance = _calculateDistance(
          location.latitude,
          location.longitude,
          restaurant.latitude,
          restaurant.longitude,
        );

        final withinDeliveryArea = distance <= restaurant.deliveryRadius;
        final withinMaxDistance = maxDistance == null || distance <= maxDistance;

        return withinDeliveryArea && withinMaxDistance;
      }).toList();
    } catch (e) {
      throw ValidationFailure('Failed to get available restaurants: $e');
    }
  }

  @override
  Future<DeliveryAreaStatus> getDeliveryAreaStatus({
    required Location userLocation,
    required String restaurantId,
  }) async {
    try {
      final isWithinArea = await isLocationInDeliveryArea(
        location: userLocation,
        restaurantId: restaurantId,
      );

      return isWithinArea
          ? DeliveryAreaStatus.withinArea
          : DeliveryAreaStatus.outsideArea;
    } catch (e) {
      if (e is LocationPermissionFailure) {
        return DeliveryAreaStatus.permissionDenied;
      } else if (e is LocationServiceFailure) {
        return DeliveryAreaStatus.locationDisabled;
      } else {
        return DeliveryAreaStatus.error;
      }
    }
  }

  @override
  Future<double> calculateDistanceToRestaurant({
    required Location userLocation,
    required String restaurantId,
  }) async {
    try {
      final restaurant = await _getRestaurantById(restaurantId);
      if (restaurant == null) {
        throw const ValidationFailure('Restaurant not found');
      }

      return _calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        restaurant.latitude,
        restaurant.longitude,
      );
    } catch (e) {
      throw ValidationFailure('Failed to calculate distance: $e');
    }
  }

  @override
  Future<double> calculateDeliveryFee({
    required Location userLocation,
    required String restaurantId,
  }) async {
    try {
      final distance = await calculateDistanceToRestaurant(
        userLocation: userLocation,
        restaurantId: restaurantId,
      );

      // Simple delivery fee calculation based on distance
      // Base fee + distance-based fee
      const baseFee = 10.0; // EGP
      const perKmFee = 3.0; // EGP per km

      return baseFee + (distance * perKmFee);
    } catch (e) {
      throw ValidationFailure('Failed to calculate delivery fee: $e');
    }
  }

  @override
  Future<int> getEstimatedDeliveryTime({
    required Location userLocation,
    required String restaurantId,
  }) async {
    try {
      final distance = await calculateDistanceToRestaurant(
        userLocation: userLocation,
        restaurantId: restaurantId,
      );

      // Simple delivery time calculation based on distance
      // Base time + distance-based time
      const baseTime = 15; // minutes
      const perKmTime = 3; // minutes per km

      return baseTime + (distance * perKmTime).round();
    } catch (e) {
      throw ValidationFailure('Failed to calculate delivery time: $e');
    }
  }

  @override
  Future<void> cacheValidationResult({
    required String restaurantId,
    required Location userLocation,
    required DeliveryAreaStatus status,
    required DateTime timestamp,
  }) async {
    // Implementation for caching validation results
    // This could use shared preferences or local database
    // For now, we'll skip implementation as it's optional for core functionality
  }

  @override
  Future<DeliveryAreaStatus?> getCachedValidationResult({
    required String restaurantId,
    required Location userLocation,
  }) async {
    // Implementation for retrieving cached validation results
    // For now, return null to always perform fresh validation
    return null;
  }

  /// Helper method to get all restaurants
  Future<List<Restaurant>> _getAllRestaurants() async {
    try {
      final snapshot = await _firestoreService.getCollection('restaurants');
      return snapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ValidationFailure('Failed to fetch restaurants: $e');
    }
  }

  /// Helper method to get restaurant by ID
  Future<Restaurant?> _getRestaurantById(String restaurantId) async {
    try {
      final doc = await _firestoreService.getDocument('restaurants/$restaurantId');
      if (!doc.exists) return null;
      return Restaurant.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw ValidationFailure('Failed to fetch restaurant: $e');
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // Earth's radius in kilometers

    final lat1Rad = lat1 * (pi / 180);
    final lon1Rad = lon1 * (pi / 180);
    final lat2Rad = lat2 * (pi / 180);
    final lon2Rad = lon2 * (pi / 180);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}
