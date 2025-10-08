/// Service for location-based search functionality
library;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../features/home/domain/entities/restaurant.dart';
import '../../features/location/domain/entities/location.dart';
import '../services/location_permissions_service.dart';
import '../services/location_service.dart';

/// Service for handling location-based search operations
class LocationSearchService {
  static LocationSearchService? _instance;
  static LocationSearchService get instance => _instance ??= LocationSearchService();

  final LocationService _locationService = LocationService.instance;
  final LocationPermissionsService _permissionsService = LocationPermissionsService.instance;

  /// Search restaurants by text query with location context
  Future<LocationSearchResult> searchWithLocation({
    required String query,
    Location? userLocation,
    double? searchRadius,
    bool useCurrentLocation = true,
  }) async {
    try {
      // Get user location if not provided and requested
      var searchLocation = userLocation ?? const Location(
        latitude: 30.0444,
        longitude: 31.2357,
      );

      if (useCurrentLocation && userLocation == null) {
        try {
          searchLocation = await _locationService.getCurrentLocation();
        } catch (e) {
          // Use default location if current location fails
          searchLocation = const Location(
            latitude: 30.0444,
            longitude: 31.2357,
          );
        }
      }

      // Perform location-based search
      // In a real implementation, this would use the search use case
      final restaurants = await _performLocationSearch(
        query: query,
        location: searchLocation,
        radius: searchRadius ?? 10.0,
      );

      return LocationSearchResult(
        query: query,
        searchLocation: searchLocation,
        restaurants: restaurants,
        searchRadius: searchRadius ?? 10.0,
        totalResults: restaurants.length,
      );
    } catch (e) {
      throw LocationSearchException('Search failed: $e');
    }
  }

  /// Search restaurants near a specific location
  Future<List<Restaurant>> searchNearbyRestaurants({
    required Location center,
    double radiusKm = 5.0,
    String? query,
    List<String>? cuisineTypes,
  }) async {
    try {
      // In a real implementation, this would use the repository
      // For now, return empty list as placeholder
      return [];
    } catch (e) {
      throw LocationSearchException('Nearby search failed: $e');
    }
  }

  /// Get search suggestions based on location and query
  Future<List<SearchSuggestion>> getSearchSuggestions({
    required String query,
    Location? userLocation,
    int limit = 5,
  }) async {
    try {
      final suggestions = <SearchSuggestion>[];

      // Add location-based suggestions
      if (userLocation != null) {
        suggestions.add(
          SearchSuggestion(
            text: 'Restaurants near me',
            type: SuggestionType.nearby,
            location: userLocation,
          ),
        );
      }

      // Add cuisine-based suggestions
      final cuisines = ['Egyptian', 'Italian', 'Fast Food', 'Cafes'];
      for (final cuisine in cuisines) {
        if (cuisine.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add(
            SearchSuggestion(
              text: '$cuisine restaurants',
              type: SuggestionType.cuisine,
              metadata: cuisine,
            ),
          );
        }
      }

      // Add area-based suggestions
      suggestions.addAll([
        const SearchSuggestion(
          text: 'Downtown restaurants',
          type: SuggestionType.area,
        ),
        const SearchSuggestion(
          text: 'Mall restaurants',
          type: SuggestionType.area,
        ),
      ]);

      return suggestions.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Search for locations/places
  Future<List<PlaceSearchResult>> searchLocations(String query) async {
    try {
      // In a real implementation, this would use geocoding API
      // For now, return common locations in Egypt
      final commonLocations = [
        const Location(
          latitude: 30.0444,
          longitude: 31.2357,
          address: 'Cairo, Egypt',
          city: 'Cairo',
          country: 'Egypt',
        ),
        const Location(
          latitude: 31.2001,
          longitude: 29.9187,
          address: 'Alexandria, Egypt',
          city: 'Alexandria',
          country: 'Egypt',
        ),
        const Location(
          latitude: 26.0975,
          longitude: 31.3207,
          address: 'Luxor, Egypt',
          city: 'Luxor',
          country: 'Egypt',
        ),
      ];

      return commonLocations
          .where((location) {
            final cityLower = location.city?.toLowerCase();
            final addressLower = location.address?.toLowerCase();
            final queryLower = query.toLowerCase();

            return (cityLower?.contains(queryLower) ?? false) ||
                   (addressLower?.contains(queryLower) ?? false);
          })
          .map((location) => PlaceSearchResult(
                location: location,
                displayName: location.address ?? '${location.city}, ${location.country}',
                type: 'city',
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Handle search with permission flow
  Future<LocationSearchResult?> searchWithPermission({
    required String query,
    required BuildContext context,
    double? searchRadius,
  }) async {
    try {
      // Check and request permissions
      final permissionResult = await _permissionsService.handlePermissionFlow(context);

      if (permissionResult.status != PermissionStatus.granted) {
        // Show error or fallback to location-less search
        return null;
      }

      // Perform search with current location
      return searchWithLocation(
        query: query,
        searchRadius: searchRadius,
        useCurrentLocation: true,
      );
    } catch (e) {
      return null;
    }
  }

  /// Perform the actual location-based search
  Future<List<Restaurant>> _performLocationSearch({
    required String query,
    required Location location,
    required double radius,
  }) async {
    // This would use the actual search use case
    // For now, return empty list as placeholder
    return [];
  }
}

/// Result of a location-based search
class LocationSearchResult {
  const LocationSearchResult({
    required this.query,
    required this.searchLocation,
    required this.restaurants,
    required this.searchRadius,
    required this.totalResults,
    this.searchTime,
  });

  final String query;
  final Location searchLocation;
  final List<Restaurant> restaurants;
  final double searchRadius;
  final int totalResults;
  final DateTime? searchTime;

  LocationSearchResult copyWith({
    String? query,
    Location? searchLocation,
    List<Restaurant>? restaurants,
    double? searchRadius,
    int? totalResults,
    DateTime? searchTime,
  }) => LocationSearchResult(
      query: query ?? this.query,
      searchLocation: searchLocation ?? this.searchLocation,
      restaurants: restaurants ?? this.restaurants,
      searchRadius: searchRadius ?? this.searchRadius,
      totalResults: totalResults ?? this.totalResults,
      searchTime: searchTime ?? this.searchTime,
    );
}

/// Search suggestion for autocomplete
class SearchSuggestion {
  const SearchSuggestion({
    required this.text,
    required this.type,
    this.location,
    this.metadata,
  });

  final String text;
  final SuggestionType type;
  final Location? location;
  final dynamic metadata;

  @override
  String toString() => 'SearchSuggestion(text: $text, type: $type)';
}

/// Types of search suggestions
enum SuggestionType {
  nearby,
  cuisine,
  area,
  restaurant,
  location,
}

/// Result of location search (for places/locations)
class PlaceSearchResult {
  const PlaceSearchResult({
    required this.location,
    required this.displayName,
    required this.type,
    this.distance,
  });

  final Location location;
  final String displayName;
  final String type;
  final double? distance;

  @override
  String toString() => 'PlaceSearchResult(displayName: $displayName, type: $type)';
}

/// Custom exception for location search errors
class LocationSearchException implements Exception {
  const LocationSearchException(this.message);

  final String message;

  @override
  String toString() => 'LocationSearchException: $message';
}
