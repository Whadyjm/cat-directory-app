import '../entities/breeds_page_result.dart';

abstract class BreedsRepository {
  Future<BreedsPageResult> getBreeds({int page = 1});
  Future<BreedsPageResult?> getCachedFirstPage();
  bool isCacheStale();
}
