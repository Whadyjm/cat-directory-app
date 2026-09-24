import '../../../breeds/domain/entities/breed.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUsecase {
  const ToggleFavoriteUsecase({required this.repository});

  final FavoritesRepository repository;

  Future<void> call(Breed breed) => repository.toggleFavorite(breed);
}
