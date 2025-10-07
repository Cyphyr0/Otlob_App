import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../domain/entities/favorite.dart';

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Favorite>>> {

  FavoritesNotifier(this._firestoreService, this._auth)
      : super(const AsyncValue.loading()) {
    _initializeFavorites();
  }
  final FirebaseFirestoreService _firestoreService;
  final FirebaseAuth _auth;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> _initializeFavorites() async {
    if (_userId.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final favoriteIds = await _firestoreService.getFavoriteIds(_userId);
      final favorites = <Favorite>[];

      for (final restaurantId in favoriteIds) {
        final restaurant = await _firestoreService.getRestaurant(restaurantId);
        if (restaurant != null) {
          favorites.add(Favorite(
            id: '${_userId}_$restaurantId',
            userId: _userId,
            restaurantId: restaurantId,
            restaurantName: restaurant.name,
            restaurantImageUrl: restaurant.imageUrl,
            createdAt: DateTime.now(), // We don't have the actual creation date in current schema
          ));
        }
      }

      state = AsyncValue.data(favorites);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshFavorites() async {
    await _initializeFavorites();
  }

  Future<bool> toggleFavorite(String restaurantId, String restaurantName, String? restaurantImageUrl) async {
    if (_userId.isEmpty) return false;

    state = const AsyncValue.loading();

    try {
      final isCurrentlyFavorite = await _firestoreService.isFavorite(_userId, restaurantId);

      if (isCurrentlyFavorite) {
        await _firestoreService.removeFromFavorites(_userId, restaurantId);
      } else {
        await _firestoreService.addToFavorites(_userId, restaurantId);
      }

      // Refresh favorites after toggle
      await _initializeFavorites();

      return !isCurrentlyFavorite;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<void> removeFavorite(String restaurantId) async {
    if (_userId.isEmpty) return;

    state = const AsyncValue.loading();

    try {
      await _firestoreService.removeFromFavorites(_userId, restaurantId);
      await _initializeFavorites();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> clearFavorites() async {
    if (_userId.isEmpty) return;

    state = const AsyncValue.loading();

    try {
      final favoriteIds = await _firestoreService.getFavoriteIds(_userId);
      for (final restaurantId in favoriteIds) {
        await _firestoreService.removeFromFavorites(_userId, restaurantId);
      }
      state = const AsyncValue.data([]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  bool isFavorite(String restaurantId) => state.maybeWhen(
      data: (favorites) => favorites.any((fav) => fav.restaurantId == restaurantId),
      orElse: () => false,
    );

  Favorite? getFavorite(String restaurantId) => state.maybeWhen(
      data: (favorites) => favorites.firstWhereOrNull((fav) => fav.restaurantId == restaurantId),
      orElse: () => null,
    );

  List<Favorite> get favorites => state.maybeWhen(
        data: (favorites) => favorites,
        orElse: () => [],
      );

  bool get isLoading => state.isLoading;
  bool get hasError => state.hasError;
  Object? get error => state.error;
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Favorite>>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final auth = FirebaseAuth.instance;

  return FavoritesNotifier(firestoreService, auth);
});

// Convenience providers for common operations
final isFavoriteProvider = Provider.family<bool, String>((ref, restaurantId) => ref.watch(favoritesProvider).maybeWhen(
    data: (favorites) => favorites.any((fav) => fav.restaurantId == restaurantId),
    orElse: () => false,
  ));

final favoriteByIdProvider = Provider.family<Favorite?, String>((ref, restaurantId) => ref.watch(favoritesProvider).maybeWhen(
    data: (favorites) => favorites.firstWhereOrNull((fav) => fav.restaurantId == restaurantId),
    orElse: () => null,
  ));

// Stream provider for real-time updates
final favoritesStreamProvider = StreamProvider<List<Favorite>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final auth = FirebaseAuth.instance;
  final userId = auth.currentUser?.uid ?? '';

  if (userId.isEmpty) return Stream.value([]);

  return firestoreService.getFavoritesStream(userId).asyncMap((favoriteIds) async {
    final favorites = <Favorite>[];

    for (final restaurantId in favoriteIds) {
      final restaurant = await firestoreService.getRestaurant(restaurantId);
      if (restaurant != null) {
        favorites.add(Favorite(
          id: '${userId}_$restaurantId',
          userId: userId,
          restaurantId: restaurantId,
          restaurantName: restaurant.name,
          restaurantImageUrl: restaurant.imageUrl,
          createdAt: DateTime.now(), // We don't have the actual creation date in current schema
        ));
      }
    }

    return favorites;
  });
});
