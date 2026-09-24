import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/breeds_page_result.dart';
import '../../domain/repositories/breeds_repository.dart';
import '../datasources/breed_local_datasource.dart';
import '../datasources/breed_remote_datasource.dart';
import '../models/breed_model.dart';

class BreedsRepositoryImpl implements BreedsRepository {
  BreedsRepositoryImpl({
    required this.remote,
    required this.local,
  });

  final BreedRemoteDatasource remote;
  final BreedLocalDatasource local;

  @override
  Future<BreedsPageResult> getBreeds({int page = 1}) async {
    try {
      final response = await remote.getBreeds(page: page);
      if (page == 1) {
        await local.cacheFirstPage(response);
      }
      return BreedsPageResult(
        breeds: response.data.map((m) => m.toEntity()).toList(),
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        total: response.total,
      );
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<BreedsPageResult?> getCachedFirstPage() async {
    try {
      final cached = await local.getCachedFirstPage();
      if (cached == null) return null;
      return BreedsPageResult(
        breeds: cached.data.map((m) => m.toEntity()).toList(),
        currentPage: cached.currentPage,
        lastPage: cached.lastPage,
        total: cached.total,
      );
    } catch (_) {
      return null;
    }
  }
}
