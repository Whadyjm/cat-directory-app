import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cat_fact.dart';
import '../../domain/repositories/cat_fact_repository.dart';
import '../datasources/cat_fact_remote_datasource.dart';

class CatFactRepositoryImpl implements CatFactRepository {
  const CatFactRepositoryImpl({required this.remote});

  final CatFactRemoteDatasource remote;

  @override
  Future<CatFact> getRandomFact() async {
    try {
      final model = await remote.getRandomFact();
      return model.toEntity();
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
