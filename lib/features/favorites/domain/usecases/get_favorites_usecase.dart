import '../../../breeds/domain/entities/breed.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUsecase {
  const GetFavoritesUsecase({required this.repository});

  final FavoritesRepository repository;

  List<Breed> call() => repository.getFavorites();
}
