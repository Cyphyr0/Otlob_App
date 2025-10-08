/// Provider for managing delivery area validation state
library;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../features/home/domain/entities/restaurant.dart';
import '../../../../features/location/domain/entities/location.dart';
import '../../domain/entities/delivery_area_validation.dart';
import '../../domain/repositories/delivery_area_repository.dart';
import '../../domain/services/delivery_area_validation_service.dart';

/// State class for delivery area validation
class DeliveryAreaValidationState {
  const DeliveryAreaValidationState({
    this.currentLocation,
    this.validations = const {},
    this.isLoading = false,
    this.error,
  });

  final Location? currentLocation;
  final Map<String, DeliveryAreaValidation> validations;
  final bool isLoading;
  final String? error;

  /// Get validation for a specific restaurant
  DeliveryAreaValidation? getValidation(String restaurantId) => validations[restaurantId];

  /// Check if a restaurant can deliver to current location
  bool canDeliverTo(String restaurantId) {
    final validation = validations[restaurantId];
    return validation?.canOrder ?? false;
  }

  /// Get all restaurants that can deliver to current location
  List<Restaurant> getAvailableRestaurants() => validations.values
        .where((validation) => validation.canOrder)
        .map((validation) => validation.restaurant)
        .toList();

  /// Create a copy with modified fields
  DeliveryAreaValidationState copyWith({
    Location? currentLocation,
    Map<String, DeliveryAreaValidation>? validations,
    bool? isLoading,
    String? error,
  }) => DeliveryAreaValidationState(
      currentLocation: currentLocation ?? this.currentLocation,
      validations: validations ?? this.validations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
}

/// Provider for delivery area validation
class DeliveryAreaValidationProvider extends ChangeNotifier {
  DeliveryAreaValidationProvider({
    required DeliveryAreaValidationService validationService,
    required DeliveryAreaRepository repository,
  })  : _validationService = validationService,
        _repository = repository;

  final DeliveryAreaValidationService _validationService;
  final DeliveryAreaRepository _repository;

  DeliveryAreaValidationState _state = const DeliveryAreaValidationState();

  /// Current state
  DeliveryAreaValidationState get state => _state;

  /// Current location
  Location? get currentLocation => _state.currentLocation;

  /// Check if currently loading
  bool get isLoading => _state.isLoading;

  /// Current error message
  String? get error => _state.error;

  /// Set current location and trigger validations
  Future<void> setCurrentLocation(Location location) async {
    _state = _state.copyWith(
      currentLocation: location,
      isLoading: true,
      error: null,
    );
    notifyListeners();

    try {
      // In a real implementation, you might want to validate multiple restaurants here
      // For now, we'll just update the location
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Failed to update location: $e',
      );
      notifyListeners();
    }
  }

  /// Validate delivery area for a specific restaurant
  Future<DeliveryAreaValidation> validateRestaurant({
    required Location userLocation,
    required Restaurant restaurant,
  }) async {
    try {
      final validation = await _validationService.validateUserLocation(
        userLocation: userLocation,
        restaurant: restaurant,
      );

      // Update state with new validation
      _state = _state.copyWith(
        validations: {
          ..._state.validations,
          restaurant.id: validation,
        },
      );
      notifyListeners();

      return validation;
    } catch (e) {
      final errorValidation = DeliveryAreaValidation.error(
        restaurant: restaurant,
        message: 'Validation failed: $e',
      );

      _state = _state.copyWith(
        validations: {
          ..._state.validations,
          restaurant.id: errorValidation,
        },
      );
      notifyListeners();

      return errorValidation;
    }
  }

  /// Validate multiple restaurants
  Future<List<DeliveryAreaValidation>> validateMultipleRestaurants({
    required Location userLocation,
    required List<Restaurant> restaurants,
  }) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final validations = await _validationService.validateMultipleRestaurants(
        userLocation: userLocation,
        restaurants: restaurants,
      );

      // Update state with all validations
      final validationMap = <String, DeliveryAreaValidation>{};
      for (final validation in validations) {
        validationMap[validation.restaurant.id] = validation;
      }

      _state = _state.copyWith(
        validations: {
          ..._state.validations,
          ...validationMap,
        },
        isLoading: false,
      );
      notifyListeners();

      return validations;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Failed to validate restaurants: $e',
      );
      notifyListeners();

      // Return error validations for all restaurants
      return restaurants.map((restaurant) => DeliveryAreaValidation.error(
          restaurant: restaurant,
          message: 'Validation failed: $e',
        )).toList();
    }
  }

  /// Get available restaurants for current location
  Future<List<Restaurant>> getAvailableRestaurants({
    Location? userLocation,
    List<Restaurant>? allRestaurants,
  }) async {
    final location = userLocation ?? _state.currentLocation;
    if (location == null) {
      return [];
    }

    try {
      return await _validationService.getAvailableRestaurants(
        userLocation: location,
        allRestaurants: allRestaurants,
      );
    } catch (e) {
      return [];
    }
  }

  /// Clear all validations
  void clearValidations() {
    _state = _state.copyWith(validations: const {});
    notifyListeners();
  }

  /// Clear error state
  void clearError() {
    _state = _state.copyWith(error: null);
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _state = const DeliveryAreaValidationState();
    notifyListeners();
  }
}