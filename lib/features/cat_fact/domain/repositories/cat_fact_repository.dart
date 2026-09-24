import '../entities/cat_fact.dart';

abstract class CatFactRepository {
  Future<CatFact> getRandomFact();
}
