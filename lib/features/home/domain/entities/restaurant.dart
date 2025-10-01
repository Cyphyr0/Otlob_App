class Restaurant {
  final String id;
  final String name;
  final double rating;
  final String imageUrl;
  final int tawseyaCount;
  final String cuisine;
  final String description;
  final List<String> menuCategories;
  final bool isOpen;
  final double distance;
  final String address;
  final double priceLevel;

  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.imageUrl,
    required this.tawseyaCount,
    required this.cuisine,
    required this.description,
    required this.menuCategories,
    required this.isOpen,
    required this.distance,
    required this.address,
    required this.priceLevel,
  });

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
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
    );
  }
}
