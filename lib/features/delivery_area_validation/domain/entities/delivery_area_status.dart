/// Delivery area status enumeration for different validation states
library;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum DeliveryAreaStatus {
  /// User is within the delivery area
  withinArea('Within Delivery Area', 'You can order from this restaurant'),

  /// User is outside the delivery area
  outsideArea('Outside Delivery Area', 'This restaurant doesn\'t deliver to your location'),

  /// Location permission is denied
  permissionDenied('Location Permission Required', 'Please enable location to check delivery availability'),

  /// Location services are disabled
  locationDisabled('Location Services Disabled', 'Please enable location services to check delivery areas'),

  /// Location is being determined
  determining('Checking Location...', 'Determining your location to check delivery availability'),

  /// Unknown error occurred
  error('Unable to Check', 'Something went wrong while checking delivery area');

  const DeliveryAreaStatus(this.displayName, this.description);

  final String displayName;
  final String description;

  /// Get color for status indicator
  Color get color {
    switch (this) {
      case DeliveryAreaStatus.withinArea:
        return DeliveryAreaStatusColor.withinArea;
      case DeliveryAreaStatus.outsideArea:
        return DeliveryAreaStatusColor.outsideArea;
      case DeliveryAreaStatus.permissionDenied:
      case DeliveryAreaStatus.locationDisabled:
      case DeliveryAreaStatus.error:
        return DeliveryAreaStatusColor.error;
      case DeliveryAreaStatus.determining:
        return DeliveryAreaStatusColor.determining;
    }
  }

  /// Check if user can order from restaurant
  bool get canOrder {
    switch (this) {
      case DeliveryAreaStatus.withinArea:
        return true;
      case DeliveryAreaStatus.outsideArea:
      case DeliveryAreaStatus.permissionDenied:
      case DeliveryAreaStatus.locationDisabled:
      case DeliveryAreaStatus.error:
      case DeliveryAreaStatus.determining:
        return false;
    }
  }
}

/// Color configuration for delivery area status
class DeliveryAreaStatusColor {
  static const withinArea = Color(0xFF4CAF50); // Green
  static const outsideArea = Color(0xFFF44336); // Red
  static const error = Color(0xFFFF9800); // Orange
  static const determining = Color(0xFF2196F3); // Blue
}