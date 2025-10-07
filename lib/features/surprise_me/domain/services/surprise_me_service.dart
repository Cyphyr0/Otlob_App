import '../../../favorites/domain/entities/favorite.dart';
import '../../../home/domain/entities/restaurant.dart';
import '../../../tawseya/domain/entities/tawseya_item.dart';
import '../../../user_preferences/domain/entities/user_preferences.dart';
import '../entities/surprise_me_result.dart';
import 'smart_suggestion_service.dart';

class SurpriseMeService {
  final SmartSuggestionService _suggestionService = SmartSuggestionService();

  Future<SurpriseMeResult> generateSurprise({
    required List<Restaurant> restaurants,
    required UserPreferences? userPreferences,
    required List<Favorite> userFavorites,
    required List<TawseyaItem> tawseyaItems,
    required String currentUserId,
  }) async {
    // Get smart suggestions based on user preferences
    final suggestions = _suggestionService.suggestRestaurants(
      restaurants: restaurants,
      userPreferences: userPreferences,
      userFavorites: userFavorites,
      tawseyaItems: tawseyaItems,
      maxSuggestions: 5, // Get top 5 suggestions
    );

    if (suggestions.isEmpty) {
      throw Exception('No restaurants available for suggestions');
    }

    // Select a random restaurant from the top suggestions
    final selectedRestaurant = suggestions[DateTime.now().millisecond % suggestions.length];

    // Generate a fun message based on the selection reasoning
    final message = _generateSurpriseMessage(
      restaurant: selectedRestaurant,
      userPreferences: userPreferences,
      userFavorites: userFavorites,
    );

    return SurpriseMeResult(
      restaurant: selectedRestaurant,
      message: message,
      reasoning: _generateReasoning(
        restaurant: selectedRestaurant,
        userPreferences: userPreferences,
        userFavorites: userFavorites,
      ),
      confidence: _calculateConfidence(
        restaurant: selectedRestaurant,
        userPreferences: userPreferences,
        userFavorites: userFavorites,
      ),
    );
  }

  String _generateSurpriseMessage({
    required Restaurant restaurant,
    required UserPreferences? userPreferences,
    required List<Favorite> userFavorites,
  }) {
    final isFavorite = userFavorites.any((fav) => fav.restaurantId == restaurant.id);

    if (isFavorite) {
      return "🎉 We know you love ${restaurant.name}! Let's go back to this favorite spot!";
    }

    if (userPreferences?.favoriteCuisines.contains(restaurant.cuisine) ?? false) {
      return '🌟 Perfect match! ${restaurant.name} serves your favorite ${restaurant.cuisine} cuisine!';
    }

    if (restaurant.rating >= 4.5) {
      return '⭐ Highly rated! ${restaurant.name} has excellent reviews (${restaurant.rating}★)';
    }

    if (restaurant.tawseyaCount > 0) {
      return '🏆 Community favorite! ${restaurant.name} has ${restaurant.tawseyaCount} Tawseya votes!';
    }

    return "🎲 Surprise! Let's try something new at ${restaurant.name}!";
  }

  String _generateReasoning({
    required Restaurant restaurant,
    required UserPreferences? userPreferences,
    required List<Favorite> userFavorites,
  }) {
    final reasons = <String>[];

    if (userFavorites.any((fav) => fav.restaurantId == restaurant.id)) {
      reasons.add("You've marked this as a favorite restaurant");
    }

    if (userPreferences?.favoriteCuisines.contains(restaurant.cuisine) ?? false) {
      reasons.add('Matches your preferred ${restaurant.cuisine} cuisine');
    }

    if (restaurant.rating >= 4.0) {
      reasons.add('High rating (${restaurant.rating}★) from other users');
    }

    if (restaurant.tawseyaCount > 0) {
      reasons.add('Popular in the community (${restaurant.tawseyaCount} Tawseya votes)');
    }

    if (reasons.isEmpty) {
      reasons.add('A great restaurant worth trying');
    }

    return reasons.join(' • ');
  }

  double _calculateConfidence({
    required Restaurant restaurant,
    required UserPreferences? userPreferences,
    required List<Favorite> userFavorites,
  }) {
    var confidence = 0.5; // Base confidence

    // Boost confidence for favorites
    if (userFavorites.any((fav) => fav.restaurantId == restaurant.id)) {
      confidence += 0.3;
    }

    // Boost confidence for preferred cuisines
    if (userPreferences?.favoriteCuisines.contains(restaurant.cuisine) ?? false) {
      confidence += 0.2;
    }

    // Boost confidence for high ratings
    if (restaurant.rating >= 4.0) {
      confidence += 0.1;
    }

    // Boost confidence for tawseya votes
    if (restaurant.tawseyaCount > 0) {
      confidence += 0.05;
    }

    return confidence.clamp(0.0, 1.0);
  }

  bool shouldShowOnboarding(String userId) {
    // This would check if user has completed preferences setup
    // For now, return true if no preferences exist
    return true; // TODO: Implement actual check
  }
}