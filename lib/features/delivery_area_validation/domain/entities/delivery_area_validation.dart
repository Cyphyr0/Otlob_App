/// Delivery area validation result entity
import 'package:flutter/material.dart';

import '../../../../features/location/domain/entities/location.dart';
import '../../../../features/home/domain/entities/restaurant.dart';
import 'delivery_area_status.dart';

class DeliveryAreaValidation {
  const DeliveryAreaValidation({
    required this.restaurant,
    required this.userLocation,
    required this.status,
    this.distance,
    this.deliveryFee,
    this.estimatedDeliveryTime,
    this.message,
  });

  final Restaurant restaurant;
  final Location userLocation;
  final DeliveryAreaStatus status;
  final double? distance; // in kilometers
  final double? deliveryFee; // in EGP
  final int? estimatedDeliveryTime; // in minutes
  final String? message;

  /// Create a validation result for when user is within delivery area
  factory DeliveryAreaValidation.withinArea({
    required Restaurant restaurant,
    required Location userLocation,
    required double distance,
    double? deliveryFee,
    int? estimatedDeliveryTime,
  }) {
    return DeliveryAreaValidation(
      restaurant: restaurant,
      userLocation: userLocation,
      status: DeliveryAreaStatus.withinArea,
      distance: distance,
      deliveryFee: deliveryFee,
      estimatedDeliveryTime: estimatedDeliveryTime,
      message: 'Delivery available to your location',
    );
  }

  /// Create a validation result for when user is outside delivery area
  factory DeliveryAreaValidation.outsideArea({
    required Restaurant restaurant,
    required Location userLocation,
    required double distance,
  }) {
    return DeliveryAreaValidation(
      restaurant: restaurant,
      userLocation: userLocation,
      status: DeliveryAreaStatus.outsideArea,
      distance: distance,
      message: 'Restaurant doesn\'t deliver to your area',
    );
  }

  /// Create a validation result for location permission denied
  factory DeliveryAreaValidation.permissionDenied({
    required Restaurant restaurant,
  }) {
    return DeliveryAreaValidation(
      restaurant: restaurant,
      userLocation: const Location(latitude: 0, longitude: 0),
      status: DeliveryAreaStatus.permissionDenied,
      message: 'Location permission required to check delivery availability',
    );
  }

  /// Create a validation result for location services disabled
  factory DeliveryAreaValidation.locationDisabled({
    required Restaurant restaurant,
  }) {
    return DeliveryAreaValidation(
      restaurant: restaurant,
      userLocation: const Location(latitude: 0, longitude: 0),
      status: DeliveryAreaStatus.locationDisabled,
      message: 'Please enable location services to check delivery areas',
    );
  }

  /// Create a validation result for determining location
  factory DeliveryAreaValidation.determining({
    required Restaurant restaurant,
  }) {
    return DeliveryAreaValidation(
      restaurant: restaurant,
      userLocation: const Location(latitude: 0, longitude: 0),
      status: DeliveryAreaStatus.determining,
      message: 'Checking your location...',
    );
  }

  /// Create a validation result for error state
  factory DeliveryAreaValidation.error({
    required Restaurant restaurant,
    String? message,
  }) {
    return DeliveryAreaValidation(
      restaurant: restaurant,
      userLocation: const Location(latitude: 0, longitude: 0),
      status: DeliveryAreaStatus.error,
      message: message ?? 'Unable to check delivery area',
    );
  }

  /// Get color for the current status
  Color get statusColor => status.color;

  /// Check if user can order from this restaurant
  bool get canOrder => status.canOrder;

  /// Get formatted distance string
  String get formattedDistance {
    if (distance == null) return '';
    return '${distance!.toStringAsFixed(1)} km';
  }

  /// Get formatted delivery fee string
  String get formattedDeliveryFee {
    if (deliveryFee == null) return '';
    return '${deliveryFee!.toStringAsFixed(2)} EGP';
  }

  /// Get formatted estimated delivery time string
  String get formattedDeliveryTime {
    if (estimatedDeliveryTime == null) return '';
    return '$estimatedDeliveryTime min';
  }

  /// Create a copy of this validation with modified fields
  DeliveryAreaValidation copyWith({
    Restaurant? restaurant,
    Location? userLocation,
    DeliveryAreaStatus? status,
    double? distance,
    double? deliveryFee,
    int? estimatedDeliveryTime,
    String? message,
  }) {
    return DeliveryAreaValidation(
      restaurant: restaurant ?? this.restaurant,
      userLocation: userLocation ?? this.userLocation,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'DeliveryAreaValidation(restaurant: ${restaurant.name}, status: $status, distance: $distance)';
  }
}