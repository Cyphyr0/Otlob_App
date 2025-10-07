import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../../../core/services/service_locator.dart";

import "../../data/repositories/firebase_home_repository.dart";
import "../../domain/entities/restaurant.dart";
import "../../domain/repositories/home_repository.dart";

// Repository provider - Using Firebase data
final homeRepositoryProvider = Provider<HomeRepository>((ref) => getIt<FirebaseHomeRepository>());

// Pagination state providers
final restaurantsPageProvider = StateProvider<int>((ref) => 1);
final searchPageProvider = StateProvider<int>((ref) => 1);

// Async provider for paginated restaurants
final restaurantsProvider = FutureProvider<List<Restaurant>>((ref) async {
  var repository = ref.watch(homeRepositoryProvider);
  var page = ref.watch(restaurantsPageProvider);
  return repository.getRestaurantsPaginated(page: page, limit: 20);
});

final searchQueryProvider = StateProvider<String>((ref) => "");

// Async provider for paginated filtered restaurants based on search
final filteredRestaurantsProvider = FutureProvider<List<Restaurant>>((
  ref,
) async {
  var query = ref.watch(searchQueryProvider);
  var repository = ref.watch(homeRepositoryProvider);
  var page = ref.watch(searchPageProvider);

  if (query.isEmpty) {
    return repository.getRestaurantsPaginated(page: page, limit: 20);
  }

  return repository.searchRestaurantsPaginated(query, page: page, limit: 20);
});

// Providers for carousels
final hiddenGemsProvider = FutureProvider<List<Restaurant>>((ref) async {
  var repository = ref.watch(homeRepositoryProvider);
  return repository.getHiddenGems();
});

final localHeroesProvider = FutureProvider<List<Restaurant>>((ref) async {
  var repository = ref.watch(homeRepositoryProvider);
  return repository.getLocalHeroes();
});
