import '../entities/breeds_page_result.dart';
import '../repositories/breeds_repository.dart';

class GetBreedsUsecase {
  const GetBreedsUsecase({required this.repository});

  final BreedsRepository repository;

  Future<BreedsPageResult> call({int page = 1}) =>
      repository.getBreeds(page: page);

  Future<BreedsPageResult?> getCached() => repository.getCachedFirstPage();
}
