import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/core/error/failures.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breeds_page_result.dart';
import 'package:cat_directory_app/features/breeds/domain/usecases/get_breeds_usecase.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:cat_directory_app/features/breeds/presentation/bloc/breeds_state.dart';

class MockGetBreedsUsecase extends Mock implements GetBreedsUsecase {}

void main() {
  late MockGetBreedsUsecase mockUsecase;
  late BreedsBloc bloc;

  const tBreed1 = Breed(
    breed: 'Abyssinian',
    country: 'Ethiopia',
    origin: 'Natural',
    coat: 'Short',
    pattern: 'Ticked',
  );

  const tBreed2 = Breed(
    breed: 'Bengal',
    country: 'United States',
    origin: 'Hybrid',
    coat: 'Short',
    pattern: 'Spotted',
  );

  const tPage1Result = BreedsPageResult(
    breeds: [tBreed1],
    currentPage: 1,
    lastPage: 2,
    total: 2,
  );

  const tPage2Result = BreedsPageResult(
    breeds: [tBreed2],
    currentPage: 2,
    lastPage: 2,
    total: 2,
  );

  setUp(() {
    mockUsecase = MockGetBreedsUsecase();
    bloc = BreedsBloc(usecase: mockUsecase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state has default empty values', () {
    expect(bloc.state.allBreeds, isEmpty);
    expect(bloc.state.filteredBreeds, isEmpty);
    expect(bloc.state.isLoadingInitial, isFalse);
    expect(bloc.state.currentPage, equals(0));
    expect(bloc.state.hasNextPage, isTrue);
  });

  blocTest<BreedsBloc, BreedsState>(
    'emits remote data when LoadBreeds succeeds with no cache',
    build: () {
      when(() => mockUsecase.getCached()).thenAnswer((_) async => null);
      when(() => mockUsecase.call(page: 1)).thenAnswer((_) async => tPage1Result);
      return bloc;
    },
    act: (b) => b.add(const LoadBreeds()),
    expect: () => [
      predicate<BreedsState>((s) => s.isLoadingInitial),
      predicate<BreedsState>(
        (s) =>
            !s.isLoadingInitial &&
            s.allBreeds == tPage1Result.breeds &&
            s.currentPage == 1 &&
            s.hasNextPage == true &&
            !s.isFromCache,
      ),
    ],
  );

  blocTest<BreedsBloc, BreedsState>(
    'emits failure when LoadBreeds fails and there is no cache',
    build: () {
      when(() => mockUsecase.getCached()).thenAnswer((_) async => null);
      when(() => mockUsecase.call(page: 1))
          .thenThrow(const NetworkFailure('No internet connection.'));
      return bloc;
    },
    act: (b) => b.add(const LoadBreeds()),
    expect: () => [
      predicate<BreedsState>((s) => s.isLoadingInitial),
      predicate<BreedsState>(
        (s) =>
            !s.isLoadingInitial &&
            s.failure is NetworkFailure &&
            s.allBreeds.isEmpty,
      ),
    ],
  );

  blocTest<BreedsBloc, BreedsState>(
    'emits appended list when LoadMoreBreeds succeeds',
    build: () {
      when(() => mockUsecase.call(page: 2)).thenAnswer((_) async => tPage2Result);
      return bloc;
    },
    seed: () => const BreedsState(
      allBreeds: [tBreed1],
      filteredBreeds: [tBreed1],
      currentPage: 1,
      hasNextPage: true,
    ),
    act: (b) => b.add(const LoadMoreBreeds()),
    expect: () => [
      predicate<BreedsState>((s) => s.isLoadingMore),
      predicate<BreedsState>(
        (s) =>
            !s.isLoadingMore &&
            s.allBreeds.length == 2 &&
            s.currentPage == 2 &&
            !s.hasNextPage,
      ),
    ],
  );

  blocTest<BreedsBloc, BreedsState>(
    'filters breeds list when SearchBreeds is emitted',
    build: () => bloc,
    seed: () => const BreedsState(
      allBreeds: [tBreed1, tBreed2],
      filteredBreeds: [tBreed1, tBreed2],
    ),
    act: (b) => b.add(const SearchBreeds('beng')),
    wait: const Duration(milliseconds: 400),
    expect: () => [
      predicate<BreedsState>(
        (s) =>
            s.searchQuery == 'beng' &&
            s.filteredBreeds.length == 1 &&
            s.filteredBreeds.first.breed == 'Bengal',
      ),
    ],
  );
}
