import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cat_fact.dart';
import '../../domain/repositories/cat_fact_repository.dart';
import '../datasources/cat_fact_remote_datasource.dart';
import '../datasources/cat_fact_translation_datasource.dart';

class CatFactRepositoryImpl implements CatFactRepository {
  const CatFactRepositoryImpl({
    required this.remote,
    this.translator,
  });

  final CatFactRemoteDatasource remote;
  final CatFactTranslationDatasource? translator;

  @override
  Future<CatFact> getRandomFact() async {
    try {
      final model = await remote.getRandomFact();
      String? factEs;
      if (translator != null) {
        factEs = await translator!.translateToSpanish(model.fact);
      }
      return CatFact(
        fact: model.fact,
        length: model.length,
        factEs: factEs,
      );
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
