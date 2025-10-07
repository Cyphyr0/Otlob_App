/// Data model for delivery area (for serialization/deserialization)
import '../../../../features/location/domain/entities/location.dart';

class DeliveryAreaModel {
  const DeliveryAreaModel({
    required this.center,
    required this.radius,
    this.name,
    this.description,
  });

  final Location center;
  final double radius; // in kilometers
  final String? name;
  final String? description;

  /// Create from domain entity
  factory DeliveryAreaModel.fromEntity(DeliveryArea entity) {
    return DeliveryAreaModel(
      center: entity.center,
      radius: entity.radius,
      name: entity.name,
      description: entity.description,
    );
  }

  /// Convert to domain entity
  DeliveryArea toEntity() {
    return DeliveryArea(
      center: center,
      radius: radius,
      name: name,
      description: description,
    );
  }

  /// Create from JSON
  factory DeliveryAreaModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAreaModel(
      center: Location.fromMap(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'center': center.toMap(),
      'radius': radius,
      'name': name,
      'description': description,
    };
  }

  /// Create a copy with modified fields
  DeliveryAreaModel copyWith({
    Location? center,
    double? radius,
    String? name,
    String? description,
  }) {
    return DeliveryAreaModel(
      center: center ?? this.center,
      radius: radius ?? this.radius,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'DeliveryAreaModel(center: $center, radius: $radius km)';
  }
}