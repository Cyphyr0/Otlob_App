/// Location service for handling geolocation and geocoding operations
library;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../features/location/domain/entities/location.dart' as app_location;

/// Service for handling device location and geocoding operations
class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService();

  /// Get current device location with option for manual selection
  Future<app_location.Location> getCurrentLocation({
    bool allowManualSelection = false,
  }) async {
    try {
      // Check location permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const LocationServiceException(
            'Location permissions are denied',
            LocationErrorType.permissionDenied,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationServiceException(
          'Location permissions are permanently denied',
          LocationErrorType.permissionDeniedForever,
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final placemark = placemarks.first;

      return app_location.Location(
        latitude: position.latitude,
        longitude: position.longitude,
        address: _buildAddress(placemark),
        city: placemark.locality,
        country: placemark.country,
      );
    } catch (e) {
      if (e is LocationServiceException) {
        rethrow;
      }
      throw LocationServiceException(
        'Failed to get current location: $e',
        LocationErrorType.locationError,
      );
    }
  }

  /// Get location with manual selection option
  Future<app_location.Location> getLocationWithManualOption({
    required bool useManualSelection,
    app_location.Location? manualLocation,
  }) async {
    if (useManualSelection && manualLocation != null) {
      // Use the manually selected location
      return manualLocation;
    } else {
      // Use GPS location
      return getCurrentLocation();
    }
  }

  /// Get location from address string
  Future<app_location.Location> getLocationFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        throw LocationServiceException(
          'No location found for address: $address',
          LocationErrorType.addressNotFound,
        );
      }

      final location = locations.first;

      // Get detailed address info
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      final placemark = placemarks.first;

      return app_location.Location(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
        city: placemark.locality,
        country: placemark.country,
      );
    } catch (e) {
      if (e is LocationServiceException) {
        rethrow;
      }
      throw LocationServiceException(
        'Failed to geocode address: $e',
        LocationErrorType.geocodingError,
      );
    }
  }

  /// Get address from coordinates
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return '$latitude, $longitude';
      }

      final placemark = placemarks.first;
      return _buildAddress(placemark);
    } catch (e) {
      return '$latitude, $longitude';
    }
  }

  /// Calculate distance between two locations in kilometers
  Future<double> calculateDistance(
    app_location.Location from,
    app_location.Location to,
  ) async {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    ) / 1000; // Convert meters to kilometers
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async => Geolocator.isLocationServiceEnabled();

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings for permissions
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Check and request location permissions
  Future<LocationPermission> checkAndRequestPermission() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Build a formatted address string from placemark
  String _buildAddress(Placemark placemark) {
    final parts = <String>[];

    if (placemark.street?.isNotEmpty ?? false) {
      parts.add(placemark.street!);
    }
    if (placemark.subLocality?.isNotEmpty ?? false) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality?.isNotEmpty ?? false) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea?.isNotEmpty ?? false) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.country?.isNotEmpty ?? false) {
      parts.add(placemark.country!);
    }

    return parts.isNotEmpty ? parts.join(', ') : 'Unknown location';
  }

  /// Get location updates stream
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // Minimum distance (in meters) to trigger updates
  }) => Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );

  /// Convert Position to app Location
  app_location.Location positionToLocation(Position position) => app_location.Location(
      latitude: position.latitude,
      longitude: position.longitude,
    );
}

/// Custom exception for location service errors
class LocationServiceException implements Exception {
  const LocationServiceException(this.message, this.errorType);

  final String message;
  final LocationErrorType errorType;

  @override
  String toString() => 'LocationServiceException: $message';
}

/// Types of location errors
enum LocationErrorType {
  permissionDenied,
  permissionDeniedForever,
  locationError,
  geocodingError,
  addressNotFound,
  serviceDisabled,
}