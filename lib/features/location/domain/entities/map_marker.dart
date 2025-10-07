/// Map marker entity for displaying restaurants and other points of interest on the map
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'location.dart';
import '../../../../features/home/domain/entities/restaurant.dart';
class MapMarker {
  const MapMarker({
    required this.id,
    required this.position,
    required this.title,
    this.snippet,
    this.icon,
    this.anchor,
    this.infoWindow,
    this.onTap,
    this.markerType = MarkerType.restaurant,
    this.restaurant,
  });

  final String id;
  final Location position;
  final String title;
  final String? snippet;
  final MarkerIcon? icon;
  final Anchor? anchor;
  final InfoWindow? infoWindow;
  final VoidCallback? onTap;
  final MarkerType markerType;
  final Restaurant? restaurant;

  /// Create a restaurant marker
  factory MapMarker.restaurant({
    required Restaurant restaurant,
    VoidCallback? onTap,
  }) {
    return MapMarker(
      id: 'restaurant_${restaurant.id}',
      position: Location(
        latitude: restaurant.latitude,
        longitude: restaurant.longitude,
        address: restaurant.address,
      ),
      title: restaurant.name,
      snippet: '${restaurant.cuisine} • ${restaurant.rating} ⭐',
      markerType: MarkerType.restaurant,
      restaurant: restaurant,
      onTap: onTap,
    );
  }

  /// Create a user location marker
  factory MapMarker.userLocation({
    required Location location,
    String title = 'Your Location',
    VoidCallback? onTap,
  }) {
    return MapMarker(
      id: 'user_location',
      position: location,
      title: title,
      markerType: MarkerType.userLocation,
      onTap: onTap,
    );
  }

  /// Create a copy of this MapMarker with modified fields
  MapMarker copyWith({
    String? id,
    Location? position,
    String? title,
    String? snippet,
    MarkerIcon? icon,
    Anchor? anchor,
    InfoWindow? infoWindow,
    VoidCallback? onTap,
    MarkerType? markerType,
    Restaurant? restaurant,
  }) {
    return MapMarker(
      id: id ?? this.id,
      position: position ?? this.position,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      icon: icon ?? this.icon,
      anchor: anchor ?? this.anchor,
      infoWindow: infoWindow ?? this.infoWindow,
      onTap: onTap ?? this.onTap,
      markerType: markerType ?? this.markerType,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  String toString() {
    return 'MapMarker(id: $id, title: $title, position: $position)';
  }
}

/// Types of markers that can be displayed on the map
enum MarkerType {
  restaurant,
  userLocation,
  deliveryArea,
  favorite,
}

/// Marker icon configuration
class MarkerIcon {
  const MarkerIcon({
    this.assetPath,
    this.iconData,
    this.size = const Size(48, 48),
    this.color,
  });

  final String? assetPath;
  final IconData? iconData;
  final Size size;
  final Color? color;

  /// Predefined restaurant marker icon
  static const MarkerIcon restaurant = MarkerIcon(
    iconData: Icons.restaurant,
    size: Size(40, 40),
    color: Colors.red,
  );

  /// Predefined user location marker icon
  static const MarkerIcon userLocation = MarkerIcon(
    iconData: Icons.my_location,
    size: Size(32, 32),
    color: Colors.blue,
  );

  /// Predefined favorite marker icon
  static const MarkerIcon favorite = MarkerIcon(
    iconData: Icons.favorite,
    size: Size(36, 36),
    color: Colors.pink,
  );
}

/// Anchor point for marker positioning
class Anchor {
  const Anchor({
    this.x = 0.5,
    this.y = 1.0,
  });

  final double x; // 0.0 (left) to 1.0 (right)
  final double y; // 0.0 (top) to 1.0 (bottom)

  /// Center-bottom anchor (default for most markers)
  static const Anchor centerBottom = Anchor(x: 0.5, y: 1.0);

  /// Center-center anchor
  static const Anchor center = Anchor(x: 0.5, y: 0.5);

  /// Center-top anchor
  static const Anchor centerTop = Anchor(x: 0.5, y: 0.0);
}

/// Info window configuration for markers
class InfoWindow {
  const InfoWindow({
    required this.title,
    this.snippet,
    this.anchor = const Anchor(x: 0.5, y: 0.0),
  });

  final String title;
  final String? snippet;
  final Anchor anchor;

  /// Create info window from restaurant data
  factory InfoWindow.fromRestaurant(Restaurant restaurant) {
    return InfoWindow(
      title: restaurant.name,
      snippet: '${restaurant.cuisine}\nRating: ${restaurant.rating} ⭐\nDistance: ${restaurant.distance.toStringAsFixed(1)} km',
    );
  }
}

/// Utility class for calculating marker positions and clustering
class MarkerUtils {
  /// Calculate the center point of multiple locations
  static Location calculateCenter(List<Location> locations) {
    if (locations.isEmpty) {
      throw ArgumentError('Locations list cannot be empty');
    }

    double totalLat = 0;
    double totalLng = 0;

    for (final location in locations) {
      totalLat += location.latitude;
      totalLng += location.longitude;
    }

    return Location(
      latitude: totalLat / locations.length,
      longitude: totalLng / locations.length,
    );
  }

  /// Calculate the bounding box for a list of locations
  static MapBounds calculateBounds(List<Location> locations) {
    if (locations.isEmpty) {
      throw ArgumentError('Locations list cannot be empty');
    }

    double minLat = locations.first.latitude;
    double maxLat = locations.first.latitude;
    double minLng = locations.first.longitude;
    double maxLng = locations.first.longitude;

    for (final location in locations) {
      minLat = min(minLat, location.latitude);
      maxLat = max(maxLat, location.latitude);
      minLng = min(minLng, location.longitude);
      maxLng = max(maxLng, location.longitude);
    }

    return MapBounds(
      northeast: Location(latitude: maxLat, longitude: maxLng),
      southwest: Location(latitude: minLat, longitude: minLng),
    );
  }

  /// Check if two markers are close enough to be clustered
  static bool shouldCluster(MapMarker marker1, MapMarker marker2, double thresholdKm) {
    final distance = _calculateDistance(marker1.position, marker2.position);
    return distance <= thresholdKm;
  }

  static double _calculateDistance(Location from, Location to) {
    const earthRadius = 6371; // Earth's radius in kilometers

    final lat1Rad = from.latitude * (pi / 180);
    final lon1Rad = from.longitude * (pi / 180);
    final lat2Rad = to.latitude * (pi / 180);
    final lon2Rad = to.longitude * (pi / 180);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}

/// Map bounds for viewport calculations
class MapBounds {
  const MapBounds({
    required this.northeast,
    required this.southwest,
  });

  final Location northeast;
  final Location southwest;

  /// Calculate the center of the bounds
  Location get center => Location(
    latitude: (northeast.latitude + southwest.latitude) / 2,
    longitude: (northeast.longitude + southwest.longitude) / 2,
  );

  /// Calculate the span/distance of the bounds
  double get latitudeSpan => northeast.latitude - southwest.latitude;
  double get longitudeSpan => northeast.longitude - southwest.longitude;

  @override
  String toString() {
    return 'MapBounds(northeast: $northeast, southwest: $southwest)';
  }
}