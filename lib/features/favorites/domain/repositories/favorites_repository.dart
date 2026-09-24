import '../../../breeds/domain/entities/breed.dart';

abstract class FavoritesRepository {
  List<Breed> getFavorites();
  Future<void> toggleFavorite(Breed breed);
  bool isFavorite(String breedName);
}
