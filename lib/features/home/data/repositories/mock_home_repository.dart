import '../../../../core/config/app_config.dart';
import '../../../../core/services/unsplash_service.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/home_repository.dart';

class MockHomeRepository implements HomeRepository {

  MockHomeRepository([this._unsplashService]);
  final UnsplashService? _unsplashService;

  final List<Restaurant> _mockRestaurants = [
    const Restaurant(
      id: '1',
      name: "Mama's Kitchen",
      rating: 4.8,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 25,
      cuisine: 'Egyptian',
      description:
          'Authentic home-cooked Egyptian meals with fresh ingredients.',
      menuCategories: ['Mains', 'Sides', 'Desserts'],
      isOpen: true,
      distance: 1.2,
      address: 'Downtown Cairo',
      priceLevel: 2,
      latitude: 30.0444,
      longitude: 31.2357,
      isFavorite: false,
    ),
    const Restaurant(
      id: '2',
      name: 'Street Food Haven',
      rating: 4.6,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 18,
      cuisine: 'Street Food',
      description: 'Vibrant street eats from local vendors.',
      menuCategories: ['Snacks', 'Drinks'],
      isOpen: true,
      distance: 0.8,
      address: 'Khan el-Khalili',
      priceLevel: 1,
      latitude: 30.0478,
      longitude: 31.2620,
      isFavorite: false,
    ),
    const Restaurant(
      id: '3',
      name: 'Local Spice House',
      rating: 4.9,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 32,
      cuisine: 'Indian',
      description: 'Spicy curries and aromatic biryanis.',
      menuCategories: ['Curries', 'Breads', 'Rice'],
      isOpen: true,
      distance: 2.5,
      address: 'Maadi',
      priceLevel: 2.5,
      latitude: 29.9598,
      longitude: 31.2728,
      isFavorite: false,
    ),
    const Restaurant(
      id: '4',
      name: "Grandma's Bakery",
      rating: 4.7,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 22,
      cuisine: 'Bakery',
      description: 'Freshly baked breads and pastries daily.',
      menuCategories: ['Breads', 'Pastries', 'Cakes'],
      isOpen: true,
      distance: 1.5,
      address: 'Zamalek',
      priceLevel: 1.5,
      latitude: 30.0630,
      longitude: 31.2197,
      isFavorite: false,
    ),
    const Restaurant(
      id: '5',
      name: 'River Side Grill',
      rating: 4.5,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 15,
      cuisine: 'Grill',
      description: 'Grilled meats with Nile views.',
      menuCategories: ['Meats', 'Seafood', 'Salads'],
      isOpen: true,
      distance: 3,
      address: 'Corniche',
      priceLevel: 3,
      latitude: 30.0444,
      longitude: 31.2357,
      isFavorite: false,
    ),
    const Restaurant(
      id: '6',
      name: 'Authentic Falafel Spot',
      rating: 4.8,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 28,
      cuisine: 'Egyptian',
      description: 'Crispy falafel and tahini wraps.',
      menuCategories: ['Falafel', 'Shawarma', 'Sides'],
      isOpen: true,
      distance: 0.5,
      address: 'Sayeda Zeinab',
      priceLevel: 1,
      latitude: 30.0364,
      longitude: 31.2135,
      isFavorite: false,
    ),
    const Restaurant(
      id: '7',
      name: 'Nile View Cafe',
      rating: 4.4,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 12,
      cuisine: 'Cafe',
      description: 'Coffee and light bites by the river.',
      menuCategories: ['Coffee', 'Pastries', 'Sandwiches'],
      isOpen: true,
      distance: 2,
      address: 'Giza',
      priceLevel: 1.5,
      latitude: 30.0131,
      longitude: 31.2089,
      isFavorite: false,
    ),
    const Restaurant(
      id: '8',
      name: 'Desert Rose Restaurant',
      rating: 4.7,
      imageUrl: null, // TODO: Replace with Unsplash API
      tawseyaCount: 20,
      cuisine: 'Mediterranean',
      description: 'Mediterranean flavors with a twist.',
      menuCategories: ['Mezze', 'Mains', 'Desserts'],
      isOpen: true,
      distance: 4,
      address: 'Heliopolis',
      priceLevel: 2.5,
      latitude: 30.0920,
      longitude: 31.3210,
      isFavorite: false,
    ),
  ];

  @override
  Future<List<Restaurant>> getRestaurants() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // If Unsplash service is available, fetch real images
    if (_unsplashService != null && AppConfig.unsplashAccessKey.isNotEmpty) {
      var restaurantsWithImages = <Restaurant>[];
      for (final restaurant in _mockRestaurants) {
        var imageUrl = await _unsplashService.getFoodImageUrl(
          restaurant.cuisine,
        );
        var updatedRestaurant = restaurant.copyWith(imageUrl: imageUrl);
        restaurantsWithImages.add(updatedRestaurant);
      }
      return restaurantsWithImages;
    }

    // Return mock data without images
    return _mockRestaurants;
  }

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    if (query.isEmpty) {
      return getRestaurants();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return _mockRestaurants
        .where(
          (restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
              restaurant.cuisine.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<List<Restaurant>> getHiddenGems() async {
    // Restaurants with high rating but lower tawseya count (less discovered)
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockRestaurants
        .where(
          (restaurant) =>
              restaurant.rating >= 4.7 && restaurant.tawseyaCount <= 25,
        )
        .toList();
  }

  @override
  Future<List<Restaurant>> getLocalHeroes() async {
    // Restaurants with high tawseya count (community favorites)
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockRestaurants
        .where((restaurant) => restaurant.tawseyaCount >= 20)
        .toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var allRestaurants = await getRestaurants();
    var startIndex = (page - 1) * limit;
    var endIndex = startIndex + limit;

    if (startIndex >= allRestaurants.length) {
      return [];
    }

    return allRestaurants.sublist(
      startIndex,
      endIndex > allRestaurants.length ? allRestaurants.length : endIndex,
    );
  }

  @override
  Future<List<Restaurant>> searchRestaurantsPaginated(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    if (query.isEmpty) {
      return getRestaurantsPaginated(page: page, limit: limit);
    }

    await Future.delayed(const Duration(milliseconds: 300));

    var allResults = await searchRestaurants(query);
    var startIndex = (page - 1) * limit;
    var endIndex = startIndex + limit;

    if (startIndex >= allResults.length) {
      return [];
    }

    return allResults.sublist(
      startIndex,
      endIndex > allResults.length ? allResults.length : endIndex,
    );
  }

  @override
  Future<void> toggleFavorite(String restaurantId) async {
    // Mock implementation - in real app would update backend
    await Future.delayed(const Duration(milliseconds: 200));
    // This would update the restaurant's favorite status
    // For now, just simulate the operation
  }
}
