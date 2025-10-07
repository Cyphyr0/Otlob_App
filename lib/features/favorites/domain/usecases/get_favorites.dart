import '../entities/favorite.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  const GetFavorites(this.repository);

  final FavoritesRepository repository;

  Future<List<Favorite>> call() async {
    return repository.getFavorites();
  }

  Stream<List<Favorite>> watch() {
    return repository.watchFavorites();
  }
}