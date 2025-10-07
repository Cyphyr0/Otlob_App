/// Repository for location-based restaurant queries and map operations
library;
import 'dart:math';

import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../../../features/home/domain/entities/restaurant.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/map_marker.dart';

/// Repository interface for map operations
abstract class MapRepository {
  /// Get restaurants within a specific radius from a location
  Future<List<Restaurant>> getRestaurantsInRadius({
    required Location center,
    required double radiusKm,
    List<String>? cuisineTypes,
    double? minRating,
    bool? isOpen,
  });

  /// Get restaurants within a bounding box (for map viewport queries)
  Future<List<Restaurant>> getRestaurantsInBounds({
    required Location northeast,
    required Location southwest,
    List<String>? cuisineTypes,
    double? minRating,
    bool? isOpen,
  });

  /// Search restaurants by location name or address
  Future<List<Restaurant>> searchRestaurantsByLocation({
    required String query,
    Location? nearLocation,
    double? radiusKm,
  });

  /// Get nearby restaurants with delivery availability
  Future<List<Restaurant>> getNearbyRestaurantsWithDelivery({
    required Location userLocation,
    double? maxDistanceKm,
  });

  /// Convert restaurants to map markers
  List<MapMarker> restaurantsToMarkers(List<Restaurant> restaurants);

  /// Get restaurant delivery areas
  Future<List<DeliveryArea>> getRestaurantDeliveryAreas(String restaurantId);

  /// Check if a location is within restaurant delivery area
  Future<bool> isLocationInDeliveryArea({
    required Location location,
    required String restaurantId,
  });
}

/// Firebase implementation of MapRepository
class FirebaseMapRepository implements MapRepository {

  FirebaseMapRepository(this._firestoreService);
  final FirebaseFirestoreService _firestoreService;

  @override
  Future<List<Restaurant>> getRestaurantsInRadius({
    required Location center,
    required double radiusKm,
    List<String>? cuisineTypes,
    double? minRating,
    bool? isOpen,
  }) async {
    try {
      // Get all restaurants first (in a real app, you'd use geo queries)
      final restaurants = await _getAllRestaurants();

      // Filter by distance and other criteria
      return restaurants.where((restaurant) {
        // Calculate distance
        final distance = _calculateDistance(
          center.latitude,
          center.longitude,
          restaurant.latitude,
          restaurant.longitude,
        );

        if (distance > radiusKm) return false;

        // Filter by cuisine
        if (cuisineTypes != null && cuisineTypes.isNotEmpty) {
          if (!cuisineTypes.contains(restaurant.cuisine)) return false;
        }

        // Filter by rating
        if (minRating != null && restaurant.rating < minRating) return false;

        // Filter by open status
        if (isOpen != null && restaurant.isOpen != isOpen) return false;

        return true;
      }).toList();
    } catch (e) {
      throw MapRepositoryException('Failed to get restaurants in radius: $e');
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsInBounds({
    required Location northeast,
    required Location southwest,
    List<String>? cuisineTypes,
    double? minRating,
    bool? isOpen,
  }) async {
    try {
      final restaurants = await _getAllRestaurants();

      return restaurants.where((restaurant) {
        // Check if restaurant is within bounds
        if (!_isLocationInBounds(
          restaurant.latitude,
          restaurant.longitude,
          northeast,
          southwest,
        )) {
          return false;
        }

        // Apply additional filters
        if (cuisineTypes != null && cuisineTypes.isNotEmpty) {
          if (!cuisineTypes.contains(restaurant.cuisine)) return false;
        }

        if (minRating != null && restaurant.rating < minRating) return false;

        if (isOpen != null && restaurant.isOpen != isOpen) return false;

        return true;
      }).toList();
    } catch (e) {
      throw MapRepositoryException('Failed to get restaurants in bounds: $e');
    }
  }

  @override
  Future<List<Restaurant>> searchRestaurantsByLocation({
    required String query,
    Location? nearLocation,
    double? radiusKm,
  }) async {
    try {
      final restaurants = await _getAllRestaurants();

      return restaurants.where((restaurant) {
        // Search in restaurant name, cuisine, or address
        final searchText = '${restaurant.name} ${restaurant.cuisine} ${restaurant.address}'
            .toLowerCase();
        if (!searchText.contains(query.toLowerCase())) return false;

        // Filter by distance if location provided
        if (nearLocation != null && radiusKm != null) {
          final distance = _calculateDistance(
            nearLocation.latitude,
            nearLocation.longitude,
            restaurant.latitude,
            restaurant.longitude,
          );
          if (distance > radiusKm) return false;
        }

        return true;
      }).toList();
    } catch (e) {
      throw MapRepositoryException('Failed to search restaurants by location: $e');
    }
  }

  @override
  Future<List<Restaurant>> getNearbyRestaurantsWithDelivery({
    required Location userLocation,
    double? maxDistanceKm,
  }) async {
    try {
      final restaurants = await _getAllRestaurants();

      return restaurants.where((restaurant) {
        // Calculate distance to restaurant
        final distance = _calculateDistance(
          userLocation.latitude,
          userLocation.longitude,
          restaurant.latitude,
          restaurant.longitude,
        );

        // Check if within max distance
        if (maxDistanceKm != null && distance > maxDistanceKm) return false;

        // Check if restaurant delivers to user location
        // For now, assume restaurant delivers within its delivery radius
        final deliveryDistance = _calculateDistance(
          restaurant.latitude,
          restaurant.longitude,
          userLocation.latitude,
          userLocation.longitude,
        );

        return deliveryDistance <= restaurant.deliveryRadius;
      }).toList();
    } catch (e) {
      throw MapRepositoryException('Failed to get nearby restaurants with delivery: $e');
    }
  }

  @override
  List<MapMarker> restaurantsToMarkers(List<Restaurant> restaurants) => restaurants.map((restaurant) => MapMarker.restaurant(
        restaurant: restaurant,
        onTap: () {
          // Handle marker tap - could navigate to restaurant details
        },
      )).toList();

  @override
  Future<List<DeliveryArea>> getRestaurantDeliveryAreas(String restaurantId) async {
    try {
      // In a real implementation, this would fetch delivery areas from Firestore
      // For now, return a simple circular area around the restaurant
      final restaurant = await _getRestaurantById(restaurantId);
      if (restaurant == null) {
        throw MapRepositoryException('Restaurant not found: $restaurantId');
      }

      return [
        DeliveryArea(
          center: Location(
            latitude: restaurant.latitude,
            longitude: restaurant.longitude,
            address: restaurant.address,
          ),
          radius: restaurant.deliveryRadius,
          name: 'Delivery Area',
          description: 'Standard delivery area',
        ),
      ];
    } catch (e) {
      throw MapRepositoryException('Failed to get delivery areas: $e');
    }
  }

  @override
  Future<bool> isLocationInDeliveryArea({
    required Location location,
    required String restaurantId,
  }) async {
    try {
      final restaurant = await _getRestaurantById(restaurantId);
      if (restaurant == null) return false;

      final distance = _calculateDistance(
        location.latitude,
        location.longitude,
        restaurant.latitude,
        restaurant.longitude,
      );

      return distance <= restaurant.deliveryRadius;
    } catch (e) {
      return false;
    }
  }

  /// Helper method to get all restaurants
  Future<List<Restaurant>> _getAllRestaurants() async {
    try {
      final snapshot = await _firestoreService.getCollection('restaurants');
      return snapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw MapRepositoryException('Failed to fetch restaurants: $e');
    }
  }

  /// Helper method to get restaurant by ID
  Future<Restaurant?> _getRestaurantById(String restaurantId) async {
    try {
      final doc = await _firestoreService.getDocument('restaurants/$restaurantId');
      if (!doc.exists) return null;
      return Restaurant.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between two points using Haversine formula
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

  /// Check if a point is within bounding box
  bool _isLocationInBounds(
    double lat,
    double lon,
    Location northeast,
    Location southwest,
  ) => lat <= northeast.latitude &&
        lat >= southwest.latitude &&
        lon <= northeast.longitude &&
        lon >= southwest.longitude;
}

/// Custom exception for map repository errors
class MapRepositoryException implements Exception {
  const MapRepositoryException(this.message);

  final String message;

  @override
  String toString() => 'MapRepositoryException: $message';
}