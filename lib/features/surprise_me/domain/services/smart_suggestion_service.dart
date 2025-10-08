import '../../../favorites/domain/entities/favorite.dart';
import '../../../home/domain/entities/restaurant.dart';
import '../../../tawseya/domain/entities/tawseya_item.dart';
import '../../../user_preferences/domain/entities/user_preferences.dart';

class SmartSuggestionService {
  static const double _favoriteCuisineWeight = 0.4;
  static const double _favoriteRestaurantWeight = 0.3;
  static const double _tawseyaWeight = 0.2;
  static const double _ratingWeight = 0.1;

  List<Restaurant> suggestRestaurants({
    required List<Restaurant> restaurants,
    required UserPreferences? userPreferences,
    required List<Favorite> userFavorites,
    required List<TawseyaItem> tawseyaItems,
    int maxSuggestions = 10,
  }) {
    if (userPreferences == null || !userPreferences.hasPreferences) {
      // Fallback to random selection if no preferences
      return _getRandomRestaurants(restaurants, maxSuggestions);
    }

    // Calculate scores for each restaurant
    final scoredRestaurants = restaurants.map((restaurant) {
      final score = _calculateRestaurantScore(
        restaurant: restaurant,
        userPreferences: userPreferences,
        userFavorites: userFavorites,
        tawseyaItems: tawseyaItems,
      );
      return (restaurant: restaurant, score: score);
    }).toList();

    // Sort by score (highest first)
    scoredRestaurants.sort((a, b) => b.score.compareTo(a.score));

    // Return top suggestions
    return scoredRestaurants
        .take(maxSuggestions)
        .map((item) => item.restaurant)
        .toList();
  }

  double _calculateRestaurantScore({
    required Restaurant restaurant,
    required UserPreferences userPreferences,
    required List<Favorite> userFavorites,
    required List<TawseyaItem> tawseyaItems,
  }) {
    double score = 0;

    // Favorite cuisine match (40% weight)
    if (userPreferences.favoriteCuisines.contains(restaurant.cuisine)) {
      score += _favoriteCuisineWeight * 1.0;
    } else if (_isCuisineSimilar(restaurant.cuisine, userPreferences.favoriteCuisines)) {
      score += _favoriteCuisineWeight * 0.7; // Partial match for similar cuisines
    }

    // Favorite restaurant match (30% weight)
    final isFavoriteRestaurant = userFavorites.any((fav) => fav.restaurantId == restaurant.id);
    if (isFavoriteRestaurant) {
      score += _favoriteRestaurantWeight * 1.0;
    }

    // Tawseya/voting activity (20% weight)
    final tawseyaScore = _calculateTawseyaScore(restaurant, tawseyaItems);
    score += _tawseyaWeight * tawseyaScore;

    // Restaurant rating (10% weight)
    score += _ratingWeight * (restaurant.rating / 5.0);

    // Price range preference match (bonus)
    if (_matchesPriceRange(restaurant.priceLevel, userPreferences.preferredPriceRange)) {
      score += 0.05; // Small bonus for price range match
    }

    // Dietary restrictions compliance (penalty if not compliant)
    if (!_meetsDietaryRestrictions(restaurant, userPreferences.dietaryRestrictions)) {
      score *= 0.5; // Significant penalty for dietary restriction violations
    }

    return score.clamp(0.0, 1.0);
  }

  double _calculateTawseyaScore(Restaurant restaurant, List<TawseyaItem> tawseyaItems) {
    // Find tawseya items related to this restaurant's cuisine or category
    final relevantTawseya = tawseyaItems.where((item) =>
      item.category.toLowerCase() == restaurant.cuisine.toLowerCase() ||
      item.name.toLowerCase().contains(restaurant.cuisine.toLowerCase())
    );

    if (relevantTawseya.isEmpty) return 0.5; // Neutral score if no relevant tawseya

    // Calculate average rating of relevant tawseya items
    final avgRating = relevantTawseya.map((item) => item.averageRating).reduce((a, b) => a + b) / relevantTawseya.length;

    return avgRating / 5.0; // Normalize to 0-1 range
  }

  bool _isCuisineSimilar(String restaurantCuisine, List<String> preferredCuisines) {
    // Define cuisine similarity groups
    const cuisineGroups = {
      'Middle Eastern': ['Egyptian', 'Lebanese', 'Syrian', 'Turkish', 'Mediterranean'],
      'Asian': ['Chinese', 'Japanese', 'Thai', 'Korean', 'Indian'],
      'Western': ['American', 'Italian', 'French', 'German'],
      'Fast Food': ['Burgers', 'Pizza', 'Fried Chicken', 'Fast Food'],
    };

    // Find which group the restaurant cuisine belongs to
    String? restaurantGroup;
    for (final group in cuisineGroups.entries) {
      if (group.value.contains(restaurantCuisine)) {
        restaurantGroup = group.key;
        break;
      }
    }

    // Check if user prefers any cuisine from the same group
    if (restaurantGroup != null) {
      for (final preferred in preferredCuisines) {
        for (final group in cuisineGroups.entries) {
          if (group.value.contains(preferred) && group.key == restaurantGroup) {
            return true;
          }
        }
      }
    }

    return false;
  }

  bool _matchesPriceRange(double restaurantPriceLevel, PriceRange preferredRange) => switch (preferredRange) {
      PriceRange.budget => restaurantPriceLevel <= 1.5,
      PriceRange.medium => restaurantPriceLevel > 1.5 && restaurantPriceLevel <= 3.0,
      PriceRange.premium => restaurantPriceLevel > 3.0,
    };

  bool _meetsDietaryRestrictions(Restaurant restaurant, List<DietaryRestriction> restrictions) {
    // This would need to be enhanced based on actual restaurant data
    // For now, we'll assume restaurants can accommodate common restrictions
    if (restrictions.contains(DietaryRestriction.vegetarian) ||
        restrictions.contains(DietaryRestriction.vegan)) {
      // Check if restaurant has vegetarian/vegan options in menuCategories
      return restaurant.menuCategories.any((category) =>
        category.toLowerCase().contains('vegetarian') ||
        category.toLowerCase().contains('vegan') ||
        category.toLowerCase().contains('salad'));
    }

    return true; // Assume other restrictions are met for now
  }

  List<Restaurant> _getRandomRestaurants(List<Restaurant> restaurants, int count) {
    if (restaurants.length <= count) return restaurants;

    final shuffled = List<Restaurant>.from(restaurants)..shuffle();
    return shuffled.take(count).toList();
  }

  // Get cuisine recommendations based on user's willingToTry list
  List<String> getCuisineRecommendations(UserPreferences preferences) {
    if (preferences.willingToTry.isEmpty) {
      return _getDefaultCuisineRecommendations();
    }

    return preferences.willingToTry;
  }

  List<String> _getDefaultCuisineRecommendations() => [
      'Try something new!',
      'Explore different cuisines',
      'Discover hidden gems',
      'Experience local favorites',
    ];
}
