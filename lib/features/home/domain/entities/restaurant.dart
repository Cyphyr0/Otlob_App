
class Restaurant {

  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.tawseyaCount, required this.cuisine, required this.description, required this.menuCategories, required this.isOpen, required this.distance, required this.address, required this.priceLevel, required this.latitude, required this.longitude, this.imageUrl,
    this.deliveryRadius = 5.0, // Default 5km delivery radius
    this.isFavorite = false,
    this.pdfMenuUrl,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      tawseyaCount: json['tawseyaCount'] as int,
      cuisine: json['cuisine'] as String,
      description: json['description'] as String,
      menuCategories: List<String>.from(json['menuCategories'] ?? []),
      isOpen: json['isOpen'] as bool,
      distance: (json['distance'] as num).toDouble(),
      address: json['address'] as String,
      priceLevel: (json['priceLevel'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      deliveryRadius: (json['deliveryRadius'] as num?)?.toDouble() ?? 5.0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      pdfMenuUrl: json['pdfMenuUrl'] as String?,
    );
  final String id;
  final String name;
  final double rating;
  final String? imageUrl;
  final int tawseyaCount;
  final String cuisine;
  final String description;
  final List<String> menuCategories;
  final bool isOpen;
  final double distance;
  final String address;
  final double priceLevel;
  final double latitude;
  final double longitude;
  final double deliveryRadius;
  final bool isFavorite;
  final String? pdfMenuUrl;

  Restaurant copyWith({
    String? id,
    String? name,
    double? rating,
    String? imageUrl,
    int? tawseyaCount,
    String? cuisine,
    String? description,
    List<String>? menuCategories,
    bool? isOpen,
    double? distance,
    String? address,
    double? priceLevel,
    double? latitude,
    double? longitude,
    double? deliveryRadius,
    bool? isFavorite,
    String? pdfMenuUrl,
  }) => Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      tawseyaCount: tawseyaCount ?? this.tawseyaCount,
      cuisine: cuisine ?? this.cuisine,
      description: description ?? this.description,
      menuCategories: menuCategories ?? this.menuCategories,
      isOpen: isOpen ?? this.isOpen,
      distance: distance ?? this.distance,
      address: address ?? this.address,
      priceLevel: priceLevel ?? this.priceLevel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      isFavorite: isFavorite ?? this.isFavorite,
      pdfMenuUrl: pdfMenuUrl ?? this.pdfMenuUrl,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'rating': rating,
      'imageUrl': imageUrl,
      'tawseyaCount': tawseyaCount,
      'cuisine': cuisine,
      'description': description,
      'menuCategories': menuCategories,
      'isOpen': isOpen,
      'distance': distance,
      'address': address,
      'priceLevel': priceLevel,
      'latitude': latitude,
      'longitude': longitude,
      'deliveryRadius': deliveryRadius,
      'isFavorite': isFavorite,
      'pdfMenuUrl': pdfMenuUrl,
    };
}
