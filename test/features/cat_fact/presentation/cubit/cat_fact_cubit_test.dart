import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/core/error/failures.dart';
import 'package:cat_directory_app/features/cat_fact/domain/entities/cat_fact.dart';
import 'package:cat_directory_app/features/cat_fact/domain/usecases/get_random_fact_usecase.dart';
import 'package:cat_directory_app/features/cat_fact/presentation/cubit/cat_fact_cubit.dart';
import 'package:cat_directory_app/features/cat_fact/presentation/cubit/cat_fact_state.dart';

class MockGetRandomFactUsecase extends Mock implements GetRandomFactUsecase {}

void main() {
  late MockGetRandomFactUsecase mockUsecase;
  late CatFactCubit cubit;

  const tCatFact = CatFact(
    fact: 'Cats sleep 70% of their lives.',
    length: 31,
  );

  setUp(() {
    mockUsecase = MockGetRandomFactUsecase();
    cubit = CatFactCubit(getRandomFactUsecase: mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is CatFactInitial', () {
    expect(cubit.state, equals(const CatFactInitial()));
  });

  blocTest<CatFactCubit, CatFactState>(
    'emits [CatFactLoading, CatFactLoaded] when fetchRandomFact succeeds',
    build: () {
      when(() => mockUsecase()).thenAnswer((_) async => tCatFact);
      return cubit;
    },
    act: (c) => c.fetchRandomFact(),
    expect: () => [
      const CatFactLoading(),
      const CatFactLoaded(fact: tCatFact),
    ],
    verify: (_) {
      verify(() => mockUsecase()).called(1);
    },
  );

  blocTest<CatFactCubit, CatFactState>(
    'emits [CatFactLoading, CatFactError] when fetchRandomFact fails with Failure',
    build: () {
      when(() => mockUsecase()).thenThrow(const ServerFailure('Server unavailable'));
      return cubit;
    },
    act: (c) => c.fetchRandomFact(),
    expect: () => [
      const CatFactLoading(),
      const CatFactError(message: 'Server unavailable'),
    ],
    verify: (_) {
      verify(() => mockUsecase()).called(1);
    },
  );
}
