import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/entities/restaurant.dart';

class FavoritesNotifier extends StateNotifier<List<Restaurant>> {
  FavoritesNotifier() : super([]);

  void addFavorite(Restaurant restaurant) {
    if (!state.any((r) => r.id == restaurant.id)) {
      state = [...state, restaurant];
    }
  }

  void removeFavorite(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  void toggleFavorite(Restaurant restaurant) {
    final isFavorite = state.any((r) => r.id == restaurant.id);
    if (isFavorite) {
      removeFavorite(restaurant.id);
    } else {
      addFavorite(restaurant);
    }
  }

  bool isFavorite(String id) {
    return state.any((r) => r.id == id);
  }

  List<Restaurant> get favorites => state;
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Restaurant>>(
      (ref) => FavoritesNotifier(),
    );
