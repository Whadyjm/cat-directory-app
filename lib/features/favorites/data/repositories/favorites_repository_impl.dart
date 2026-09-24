import '../../../breeds/data/models/breed_model.dart';
import '../../../breeds/domain/entities/breed.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required this.localDatasource});

  final FavoritesLocalDatasource localDatasource;

  @override
  List<Breed> getFavorites() {
    return localDatasource.getFavorites().map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> toggleFavorite(Breed breed) async {
    if (localDatasource.isFavorite(breed.breed)) {
      await localDatasource.removeFavorite(breed.breed);
    } else {
      final model = BreedModel(
        breed: breed.breed,
        country: breed.country,
        origin: breed.origin,
        coat: breed.coat,
        pattern: breed.pattern,
      );
      await localDatasource.saveFavorite(model);
    }
  }

  @override
  bool isFavorite(String breedName) {
    return localDatasource.isFavorite(breedName);
  }
}
