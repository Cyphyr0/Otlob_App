/// Map provider for managing map state and location-based restaurant discovery
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../../../../core/services/location_service.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/map_marker.dart';
import '../../domain/usecases/get_restaurants_in_radius.dart';
import '../../domain/usecases/get_restaurants_in_bounds.dart';
import '../../domain/usecases/search_restaurants_by_location.dart';
import '../../domain/usecases/get_nearby_restaurants_with_delivery.dart';
import '../../../home/domain/entities/restaurant.dart';

/// State class for map-related data
class MapState {
  const MapState({
    this.currentLocation,
    this.restaurants = const [],
    this.markers = const [],
    this.isLoading = false,
    this.error,
    this.selectedRadius = 5.0,
    this.selectedCuisineTypes = const [],
    this.minRating,
    this.showDeliveryAreas = false,
    this.mapController,
    this.isManualLocationSelectionMode = false,
    this.selectedLocation,
    this.selectedLocationAddress,
  });

  final Location? currentLocation;
  final List<Restaurant> restaurants;
  final List<MapMarker> markers;
  final bool isLoading;
  final String? error;
  final double selectedRadius;
  final List<String> selectedCuisineTypes;
  final double? minRating;
  final bool showDeliveryAreas;
  final gmaps.GoogleMapController? mapController;
  final bool isManualLocationSelectionMode;
  final Location? selectedLocation;
  final String? selectedLocationAddress;

  MapState copyWith({
    Location? currentLocation,
    List<Restaurant>? restaurants,
    List<MapMarker>? markers,
    bool? isLoading,
    String? error,
    double? selectedRadius,
    List<String>? selectedCuisineTypes,
    double? minRating,
    bool? showDeliveryAreas,
    dynamic mapController,
    bool? isManualLocationSelectionMode,
    Location? selectedLocation,
    String? selectedLocationAddress,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      restaurants: restaurants ?? this.restaurants,
      markers: markers ?? this.markers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedRadius: selectedRadius ?? this.selectedRadius,
      selectedCuisineTypes: selectedCuisineTypes ?? this.selectedCuisineTypes,
      minRating: minRating ?? this.minRating,
      showDeliveryAreas: showDeliveryAreas ?? this.showDeliveryAreas,
      mapController: mapController ?? this.mapController,
      isManualLocationSelectionMode: isManualLocationSelectionMode ?? this.isManualLocationSelectionMode,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedLocationAddress: selectedLocationAddress ?? this.selectedLocationAddress,
    );
  }
}

/// Map notifier for managing map state
class MapNotifier extends StateNotifier<MapState> {
  MapNotifier(
    this._getRestaurantsInRadius,
    this._getRestaurantsInBounds,
    this._searchRestaurantsByLocation,
    this._getNearbyRestaurantsWithDelivery,
    this._locationService,
  ) : super(const MapState());

  final GetRestaurantsInRadius _getRestaurantsInRadius;
  final GetRestaurantsInBounds _getRestaurantsInBounds;
  final SearchRestaurantsByLocation _searchRestaurantsByLocation;
  final GetNearbyRestaurantsWithDelivery _getNearbyRestaurantsWithDelivery;
  final LocationService _locationService;

  /// Initialize map with current location or manual selection
  Future<void> initializeMap({bool useManualSelection = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get current location (GPS or manual)
      final location = await _locationService.getLocationWithManualOption(
        useManualSelection: useManualSelection,
        manualLocation: state.currentLocation,
      );
      state = state.copyWith(currentLocation: location);

      // Load nearby restaurants
      await loadRestaurantsInRadius(
        center: location,
        radiusKm: state.selectedRadius,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load restaurants within a radius
  Future<void> loadRestaurantsInRadius({
    required Location center,
    required double radiusKm,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final restaurants = await _getRestaurantsInRadius(
        center: center,
        radiusKm: radiusKm,
        cuisineTypes: state.selectedCuisineTypes.isNotEmpty ? state.selectedCuisineTypes : null,
        minRating: state.minRating,
      );

      final markers = _restaurantsToMarkers(restaurants);

      state = state.copyWith(
        restaurants: restaurants,
        markers: markers,
        isLoading: false,
        selectedRadius: radiusKm,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load restaurants within map bounds (viewport)
  Future<void> loadRestaurantsInBounds({
    required Location northeast,
    required Location southwest,
  }) async {
    if (state.currentLocation == null) return;

    try {
      final restaurants = await _getRestaurantsInBounds(
        northeast: northeast,
        southwest: southwest,
        cuisineTypes: state.selectedCuisineTypes.isNotEmpty ? state.selectedCuisineTypes : null,
        minRating: state.minRating,
      );

      final markers = _restaurantsToMarkers(restaurants);

      state = state.copyWith(
        restaurants: restaurants,
        markers: markers,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Search restaurants by location query
  Future<void> searchRestaurants(String query) async {
    if (state.currentLocation == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final restaurants = await _searchRestaurantsByLocation(
        query: query,
        nearLocation: state.currentLocation,
        radiusKm: state.selectedRadius,
      );

      final markers = _restaurantsToMarkers(restaurants);

      state = state.copyWith(
        restaurants: restaurants,
        markers: markers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load nearby restaurants with delivery
  Future<void> loadNearbyRestaurantsWithDelivery() async {
    if (state.currentLocation == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final restaurants = await _getNearbyRestaurantsWithDelivery(
        userLocation: state.currentLocation!,
        maxDistanceKm: state.selectedRadius,
      );

      final markers = _restaurantsToMarkers(restaurants);

      state = state.copyWith(
        restaurants: restaurants,
        markers: markers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update location filter settings
  void updateFilters({
    double? radius,
    List<String>? cuisineTypes,
    double? minRating,
  }) {
    state = state.copyWith(
      selectedRadius: radius ?? state.selectedRadius,
      selectedCuisineTypes: cuisineTypes ?? state.selectedCuisineTypes,
      minRating: minRating ?? state.minRating,
    );

    // Reload restaurants with new filters
    if (state.currentLocation != null) {
      loadRestaurantsInRadius(
        center: state.currentLocation!,
        radiusKm: state.selectedRadius,
      );
    }
  }

  /// Toggle delivery areas visibility
  void toggleDeliveryAreas() {
    state = state.copyWith(showDeliveryAreas: !state.showDeliveryAreas);
  }

  /// Set map controller
  void setMapController(gmaps.GoogleMapController controller) {
    state = state.copyWith(mapController: controller);
  }

  /// Center map on current location
  void centerOnCurrentLocation() {
    if (state.currentLocation != null && state.mapController != null) {
      // Implementation would depend on the specific map widget being used
      // This is a placeholder for the actual implementation
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Enable manual location selection mode
  void enableManualLocationSelection() {
    state = state.copyWith(isManualLocationSelectionMode: true);
  }

  /// Disable manual location selection mode
  void disableManualLocationSelection() {
    state = state.copyWith(
      isManualLocationSelectionMode: false,
      selectedLocation: null,
      selectedLocationAddress: null,
    );
  }

  /// Handle manual location selection from map tap
  Future<void> selectLocationFromMap(Location location) async {
    state = state.copyWith(isLoading: true);

    try {
      // Get address for the selected location
      final address = await _locationService.getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );

      state = state.copyWith(
        selectedLocation: location,
        selectedLocationAddress: address,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get address for selected location: $e',
      );
    }
  }

  /// Confirm manual location selection
  Future<void> confirmManualLocationSelection() async {
    if (state.selectedLocation == null) return;

    state = state.copyWith(
      currentLocation: state.selectedLocation,
      isManualLocationSelectionMode: false,
      selectedLocation: null,
      selectedLocationAddress: null,
    );

    // Load restaurants for the selected location
    await loadRestaurantsInRadius(
      center: state.currentLocation!,
      radiusKm: state.selectedRadius,
    );
  }

  /// Cancel manual location selection
  void cancelManualLocationSelection() {
    state = state.copyWith(
      isManualLocationSelectionMode: false,
      selectedLocation: null,
      selectedLocationAddress: null,
    );
  }

  /// Convert restaurants to map markers
  List<MapMarker> _restaurantsToMarkers(List<Restaurant> restaurants) {
    return restaurants.map((restaurant) {
      return MapMarker.restaurant(
        restaurant: restaurant,
        onTap: () {
          // Handle marker tap - could navigate to restaurant details
          // This would be implemented based on the app's navigation system
        },
      );
    }).toList();
  }
}

/// Provider for map state
final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  // These would need to be provided by dependency injection
  // For now, creating instances directly
  final locationService = LocationService.instance;

  return MapNotifier(
    GetRestaurantsInRadius(null), // Would be injected
    GetRestaurantsInBounds(null), // Would be injected
    SearchRestaurantsByLocation(null), // Would be injected
    GetNearbyRestaurantsWithDelivery(null), // Would be injected
    locationService,
  );
});