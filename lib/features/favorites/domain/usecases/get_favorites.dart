import '../entities/favorite.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  const GetFavorites(this.repository);

  final FavoritesRepository repository;

  Future<List<Favorite>> call() async => repository.getFavorites();

  Stream<List<Favorite>> watch() => repository.watchFavorites();
}