/// Location entity representing a geographical point with coordinates
library;
import 'dart:math';
class Location {
  const Location({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
  });

  /// Create a Location from a map (e.g., from geolocator or geocoding)
  factory Location.fromMap(Map<String, dynamic> map) => Location(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      address: map['address'],
      city: map['city'],
      country: map['country'],
    );

  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;

  /// Convert Location to a map
  Map<String, dynamic> toMap() => {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
    };

  /// Create a copy of this Location with modified fields
  Location copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
  }) => Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
    );

  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude, address: $address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

/// Delivery area representing the coverage zone for a restaurant
class DeliveryArea {
  const DeliveryArea({
    required this.center,
    required this.radius,
    this.name,
    this.description,
  });

  final Location center;
  final double radius; // in kilometers
  final String? name;
  final String? description;

  /// Check if a location is within this delivery area
  bool containsLocation(Location location) {
    final distance = calculateDistance(center, location);
    return distance <= radius;
  }

  /// Calculate distance between two locations using Haversine formula
  double calculateDistance(Location from, Location to) {
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

  /// Create a copy of this DeliveryArea with modified fields
  DeliveryArea copyWith({
    Location? center,
    double? radius,
    String? name,
    String? description,
  }) => DeliveryArea(
      center: center ?? this.center,
      radius: radius ?? this.radius,
      name: name ?? this.name,
      description: description ?? this.description,
    );

  @override
  String toString() => 'DeliveryArea(center: $center, radius: $radius km)';
}

/// Location filter for searching restaurants within a specific area
class LocationFilter {
  const LocationFilter({
    required this.center,
    required this.radius,
    this.cuisineTypes = const [],
    this.priceRange,
    this.minRating,
    this.isOpen,
  });

  final Location center;
  final double radius; // in kilometers
  final List<String> cuisineTypes;
  final double? priceRange; // 1-4 scale
  final double? minRating; // 1-5 scale
  final bool? isOpen;

  /// Create a copy of this LocationFilter with modified fields
  LocationFilter copyWith({
    Location? center,
    double? radius,
    List<String>? cuisineTypes,
    double? priceRange,
    double? minRating,
    bool? isOpen,
  }) => LocationFilter(
      center: center ?? this.center,
      radius: radius ?? this.radius,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      priceRange: priceRange ?? this.priceRange,
      minRating: minRating ?? this.minRating,
      isOpen: isOpen ?? this.isOpen,
    );

  @override
  String toString() => 'LocationFilter(center: $center, radius: $radius km, cuisines: $cuisineTypes)';
}