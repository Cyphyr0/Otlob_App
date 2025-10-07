/// Data model for delivery area (for serialization/deserialization)
library;
import '../../../../features/location/domain/entities/location.dart';

class DeliveryAreaModel {
  const DeliveryAreaModel({
    required this.center,
    required this.radius,
    this.name,
    this.description,
  });

  /// Create from domain entity
  factory DeliveryAreaModel.fromEntity(DeliveryArea entity) => DeliveryAreaModel(
      center: entity.center,
      radius: entity.radius,
      name: entity.name,
      description: entity.description,
    );

  /// Create from JSON
  factory DeliveryAreaModel.fromJson(Map<String, dynamic> json) => DeliveryAreaModel(
      center: Location.fromMap(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

  final Location center;
  final double radius; // in kilometers
  final String? name;
  final String? description;

  /// Convert to domain entity
  DeliveryArea toEntity() => DeliveryArea(
      center: center,
      radius: radius,
      name: name,
      description: description,
    );

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
      'center': center.toMap(),
      'radius': radius,
      'name': name,
      'description': description,
    };

  /// Create a copy with modified fields
  DeliveryAreaModel copyWith({
    Location? center,
    double? radius,
    String? name,
    String? description,
  }) => DeliveryAreaModel(
      center: center ?? this.center,
      radius: radius ?? this.radius,
      name: name ?? this.name,
      description: description ?? this.description,
    );

  @override
  String toString() => 'DeliveryAreaModel(center: $center, radius: $radius km)';
}