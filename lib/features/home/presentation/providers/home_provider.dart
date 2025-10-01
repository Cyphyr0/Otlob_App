import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/restaurant.dart';

final mockRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  return [
    const Restaurant(
      id: '1',
      name: 'Mama\'s Kitchen',
      rating: 4.8,
      imageUrl: 'assets/images/mamas_kitchen.jpg',
      tawseyaCount: 25,
      cuisine: 'Egyptian',
      description:
          'Authentic home-cooked Egyptian meals with fresh ingredients.',
      menuCategories: ['Mains', 'Sides', 'Desserts'],
      isOpen: true,
      distance: 1.2,
      address: 'Downtown Cairo',
      priceLevel: 2.0,
      isFavorite: false,
    ),
    const Restaurant(
      id: '2',
      name: 'Street Food Haven',
      rating: 4.6,
      imageUrl: 'assets/images/street_food.jpg',
      tawseyaCount: 18,
      cuisine: 'Street Food',
      description: 'Vibrant street eats from local vendors.',
      menuCategories: ['Snacks', 'Drinks'],
      isOpen: true,
      distance: 0.8,
      address: 'Khan el-Khalili',
      priceLevel: 1.0,
      isFavorite: false,
    ),
    const Restaurant(
      id: '3',
      name: 'Local Spice House',
      rating: 4.9,
      imageUrl: 'assets/images/spice_house.jpg',
      tawseyaCount: 32,
      cuisine: 'Indian',
      description: 'Spicy curries and aromatic biryanis.',
      menuCategories: ['Curries', 'Breads', 'Rice'],
      isOpen: true,
      distance: 2.5,
      address: 'Maadi',
      priceLevel: 2.5,
      isFavorite: false,
    ),
    const Restaurant(
      id: '4',
      name: 'Grandma\'s Bakery',
      rating: 4.7,
      imageUrl: 'assets/images/bakery.jpg',
      tawseyaCount: 22,
      cuisine: 'Bakery',
      description: 'Freshly baked breads and pastries daily.',
      menuCategories: ['Breads', 'Pastries', 'Cakes'],
      isOpen: true,
      distance: 1.5,
      address: 'Zamalek',
      priceLevel: 1.5,
      isFavorite: false,
    ),
    const Restaurant(
      id: '5',
      name: 'River Side Grill',
      rating: 4.5,
      imageUrl: 'assets/images/grill.jpg',
      tawseyaCount: 15,
      cuisine: 'Grill',
      description: 'Grilled meats with Nile views.',
      menuCategories: ['Meats', 'Seafood', 'Salads'],
      isOpen: true,
      distance: 3.0,
      address: 'Corniche',
      priceLevel: 3.0,
      isFavorite: false,
    ),
    const Restaurant(
      id: '6',
      name: 'Authentic Falafel Spot',
      rating: 4.8,
      imageUrl: 'assets/images/falafel.jpg',
      tawseyaCount: 28,
      cuisine: 'Egyptian',
      description: 'Crispy falafel and tahini wraps.',
      menuCategories: ['Falafel', 'Shawarma', 'Sides'],
      isOpen: true,
      distance: 0.5,
      address: 'Sayeda Zeinab',
      priceLevel: 1.0,
      isFavorite: false,
    ),
    const Restaurant(
      id: '7',
      name: 'Nile View Cafe',
      rating: 4.4,
      imageUrl: 'assets/images/cafe.jpg',
      tawseyaCount: 12,
      cuisine: 'Cafe',
      description: 'Coffee and light bites by the river.',
      menuCategories: ['Coffee', 'Pastries', 'Sandwiches'],
      isOpen: true,
      distance: 2.0,
      address: 'Giza',
      priceLevel: 1.5,
      isFavorite: false,
    ),
    const Restaurant(
      id: '8',
      name: 'Desert Rose Restaurant',
      rating: 4.7,
      imageUrl: 'assets/images/desert_rose.jpg',
      tawseyaCount: 20,
      cuisine: 'Mediterranean',
      description: 'Mediterranean flavors with a twist.',
      menuCategories: ['Mezze', 'Mains', 'Desserts'],
      isOpen: true,
      distance: 4.0,
      address: 'Heliopolis',
      priceLevel: 2.5,
      isFavorite: false,
    ),
  ];
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final allRestaurants = ref.watch(mockRestaurantsProvider);
  if (query.isEmpty) {
    return allRestaurants;
  }
  return allRestaurants
      .where(
        (restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.cuisine.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
});
