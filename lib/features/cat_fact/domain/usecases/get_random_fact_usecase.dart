import '../entities/cat_fact.dart';
import '../repositories/cat_fact_repository.dart';

class GetRandomFactUsecase {
  const GetRandomFactUsecase({required this.repository});

  final CatFactRepository repository;

  Future<CatFact> call() => repository.getRandomFact();
}
