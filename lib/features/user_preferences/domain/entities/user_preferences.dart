class UserPreferences {
  const UserPreferences({
    required this.userId,
    required this.favoriteCuisines,
    required this.preferredPriceRange,
    required this.dietaryRestrictions,
    required this.spiceLevel,
    required this.willingToTry,
    this.lastUpdated,
  });

  final String userId;
  final List<String> favoriteCuisines;
  final PriceRange preferredPriceRange;
  final List<DietaryRestriction> dietaryRestrictions;
  final SpiceLevel spiceLevel;
  final List<String> willingToTry;
  final DateTime? lastUpdated;

  UserPreferences copyWith({
    String? userId,
    List<String>? favoriteCuisines,
    PriceRange? preferredPriceRange,
    List<DietaryRestriction>? dietaryRestrictions,
    SpiceLevel? spiceLevel,
    List<String>? willingToTry,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      favoriteCuisines: favoriteCuisines ?? this.favoriteCuisines,
      preferredPriceRange: preferredPriceRange ?? this.preferredPriceRange,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      willingToTry: willingToTry ?? this.willingToTry,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'favoriteCuisines': favoriteCuisines,
      'preferredPriceRange': preferredPriceRange.name,
      'dietaryRestrictions': dietaryRestrictions.map((e) => e.name).toList(),
      'spiceLevel': spiceLevel.name,
      'willingToTry': willingToTry,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      userId: json['userId'] as String,
      favoriteCuisines: List<String>.from(json['favoriteCuisines'] ?? []),
      preferredPriceRange: PriceRange.values.firstWhere(
        (e) => e.name == json['preferredPriceRange'],
        orElse: () => PriceRange.medium,
      ),
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => DietaryRestriction.values.firstWhere(
                    (restriction) => restriction.name == e,
                    orElse: () => DietaryRestriction.none,
                  ))
              .toList() ??
          [],
      spiceLevel: SpiceLevel.values.firstWhere(
        (e) => e.name == json['spiceLevel'],
        orElse: () => SpiceLevel.medium,
      ),
      willingToTry: List<String>.from(json['willingToTry'] ?? []),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  bool get hasPreferences => favoriteCuisines.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() {
    return 'UserPreferences(userId: $userId, favoriteCuisines: $favoriteCuisines, preferredPriceRange: $preferredPriceRange)';
  }
}

enum PriceRange {
  budget('Budget', '\$', 'Under 100 EGP'),
  medium('Medium', '\$\$', '100-300 EGP'),
  premium('Premium', '\$\$\$', '300+ EGP');

  const PriceRange(this.displayName, this.symbol, this.range);
  final String displayName;
  final String symbol;
  final String range;
}

enum SpiceLevel {
  mild('Mild', '🌶️', 'No spice'),
  medium('Medium', '🌶️🌶️', 'Some spice'),
  hot('Hot', '🌶️🌶️🌶️', 'Very spicy'),
  extreme('Extreme', '🌶️🌶️🌶️🌶️', 'Extremely spicy');

  const SpiceLevel(this.displayName, this.icon, this.description);
  final String displayName;
  final String icon;
  final String description;
}

enum DietaryRestriction {
  none('None', 'No restrictions'),
  vegetarian('Vegetarian', 'No meat'),
  vegan('Vegan', 'No animal products'),
  halal('Halal', 'Halal certified'),
  glutenFree('Gluten Free', 'No gluten'),
  dairyFree('Dairy Free', 'No dairy'),
  nutFree('Nut Free', 'No nuts');

  const DietaryRestriction(this.displayName, this.description);
  final String displayName;
  final String description;
}