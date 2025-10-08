/// Service for handling location permissions across the app
library;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

/// Service for managing location permissions
class LocationPermissionsService {
  static LocationPermissionsService? _instance;
  static LocationPermissionsService get instance => _instance ??= LocationPermissionsService();

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async => Geolocator.isLocationServiceEnabled();

  /// Check current location permission status
  Future<LocationPermission> checkPermission() async => Geolocator.checkPermission();

  /// Request location permission
  Future<LocationPermission> requestPermission() async => Geolocator.requestPermission();

  /// Check and request location permission with detailed handling
  Future<PermissionStatus> checkAndRequestLocationPermission() async {
    try {
      // First check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return PermissionStatus.serviceDisabled;
      }

      // Check current permission status
      var permission = await checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await requestPermission();

        if (permission == LocationPermission.denied) {
          return PermissionStatus.denied;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return PermissionStatus.permanentlyDenied;
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        return PermissionStatus.granted;
      }

      return PermissionStatus.denied;
    } catch (e) {
      return PermissionStatus.error;
    }
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings for permissions
  Future<void> openAppSettings() async {
    await perm_handler.openAppSettings();
  }

  /// Check if we have the required location accuracy
  Future<bool> hasRequiredAccuracy() async {
    try {
      final permission = await checkPermission();
      return permission == LocationPermission.always ||
             permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }

  /// Get detailed permission status with explanations
  Future<LocationPermissionResult> getPermissionStatusWithExplanation() async {
    final serviceEnabled = await isLocationServiceEnabled();
    final permission = await checkPermission();

    if (!serviceEnabled) {
      return LocationPermissionResult(
        status: PermissionStatus.serviceDisabled,
        canRequest: false,
        message: 'Location services are disabled. Please enable them in your device settings.',
        actionText: 'Open Settings',
        action: openLocationSettings,
      );
    }

    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionResult(
          status: PermissionStatus.denied,
          canRequest: true,
          message: 'Location permission is required to show nearby restaurants and delivery areas.',
          actionText: 'Grant Permission',
          action: requestPermission,
        );

      case LocationPermission.deniedForever:
        return LocationPermissionResult(
          status: PermissionStatus.permanentlyDenied,
          canRequest: false,
          message: 'Location permission is permanently denied. Please enable it in app settings.',
          actionText: 'Open Settings',
          action: openAppSettings,
        );

      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return const LocationPermissionResult(
          status: PermissionStatus.granted,
          canRequest: false,
          message: 'Location permission granted.',
        );

      default:
        return LocationPermissionResult(
          status: PermissionStatus.denied,
          canRequest: true,
          message: 'Location permission is required.',
          actionText: 'Grant Permission',
          action: requestPermission,
        );
    }
  }

  /// Show permission rationale dialog
  Future<bool?> showPermissionRationale(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs access to your location to show nearby restaurants, '
          'display delivery areas, and provide location-based filtering. '
          'Your location data is only used within the app and is not shared with third parties.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not Now'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );

  /// Handle location permission flow with user feedback
  Future<LocationPermissionResult> handlePermissionFlow(BuildContext context) async {
    final status = await getPermissionStatusWithExplanation();

    if (status.status == PermissionStatus.granted) {
      return status;
    }

    if (status.canRequest) {
      // Show rationale dialog
      final shouldRequest = await showPermissionRationale(context);
      if (shouldRequest != true) {
        return status;
      }

      // Request permission
      await requestPermission();
      return getPermissionStatusWithExplanation();
    }

    return status;
  }
}

/// Result of location permission check with detailed information
class LocationPermissionResult {
  const LocationPermissionResult({
    required this.status,
    required this.canRequest,
    required this.message,
    this.actionText,
    this.action,
  });

  final PermissionStatus status;
  final bool canRequest;
  final String message;
  final String? actionText;
  final Future<void> Function()? action;
}

/// Permission status enum
enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
  error,
}

/// Extension to convert Geolocator permissions to our status
extension LocationPermissionExtension on LocationPermission {
  PermissionStatus toPermissionStatus() {
    switch (this) {
      case LocationPermission.denied:
        return PermissionStatus.denied;
      case LocationPermission.deniedForever:
        return PermissionStatus.permanentlyDenied;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return PermissionStatus.granted;
      default:
        return PermissionStatus.denied;
    }
  }
}