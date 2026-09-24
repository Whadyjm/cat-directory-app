import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/core/error/exceptions.dart';
import 'package:cat_directory_app/core/error/failures.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_local_datasource.dart';
import 'package:cat_directory_app/features/breeds/data/datasources/breed_remote_datasource.dart';
import 'package:cat_directory_app/features/breeds/data/models/breed_model.dart';
import 'package:cat_directory_app/features/breeds/data/models/breeds_response_model.dart';
import 'package:cat_directory_app/features/breeds/data/repositories/breeds_repository_impl.dart';

class MockBreedRemoteDatasource extends Mock implements BreedRemoteDatasource {}
class MockBreedLocalDatasource extends Mock implements BreedLocalDatasource {}

void main() {
  late MockBreedRemoteDatasource mockRemote;
  late MockBreedLocalDatasource mockLocal;
  late BreedsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const BreedsResponseModel(
      currentPage: 1,
      data: [],
      lastPage: 1,
      total: 0,
    ));
  });

  const tBreedModel = BreedModel(
    breed: 'Abyssinian',
    country: 'Ethiopia',
    origin: 'Natural',
    coat: 'Short',
    pattern: 'Ticked',
  );

  const tResponse = BreedsResponseModel(
    currentPage: 1,
    data: [tBreedModel],
    lastPage: 3,
    total: 30,
  );

  setUp(() {
    mockRemote = MockBreedRemoteDatasource();
    mockLocal = MockBreedLocalDatasource();
    repository = BreedsRepositoryImpl(remote: mockRemote, local: mockLocal);
  });

  test('getBreeds page 1 caches the first page and returns BreedsPageResult', () async {
    when(() => mockRemote.getBreeds(page: 1)).thenAnswer((_) async => tResponse);
    when(() => mockLocal.cacheFirstPage(any())).thenAnswer((_) async {});

    final result = await repository.getBreeds(page: 1);

    expect(result.breeds.length, equals(1));
    expect(result.breeds.first.breed, equals('Abyssinian'));
    expect(result.currentPage, equals(1));
    verify(() => mockRemote.getBreeds(page: 1)).called(1);
    verify(() => mockLocal.cacheFirstPage(tResponse)).called(1);
  });

  test('getBreeds page 2 does not cache locally and returns result', () async {
    const tResponsePage2 = BreedsResponseModel(
      currentPage: 2,
      data: [tBreedModel],
      lastPage: 3,
      total: 30,
    );

    when(() => mockRemote.getBreeds(page: 2)).thenAnswer((_) async => tResponsePage2);

    final result = await repository.getBreeds(page: 2);

    expect(result.currentPage, equals(2));
    verify(() => mockRemote.getBreeds(page: 2)).called(1);
    verifyNever(() => mockLocal.cacheFirstPage(any()));
  });

  test('getBreeds throws NetworkFailure when remote throws NetworkException', () async {
    when(() => mockRemote.getBreeds(page: 1)).thenThrow(const NetworkException());

    expect(() => repository.getBreeds(page: 1), throwsA(isA<NetworkFailure>()));
  });

  test('getCachedFirstPage returns cached result when present', () async {
    when(() => mockLocal.getCachedFirstPage()).thenAnswer((_) async => tResponse);

    final result = await repository.getCachedFirstPage();

    expect(result, isNotNull);
    expect(result!.breeds.first.breed, equals('Abyssinian'));
    verify(() => mockLocal.getCachedFirstPage()).called(1);
  });

  test('isCacheStale delegates to local datasource', () {
    when(() => mockLocal.isCacheStale()).thenReturn(true);

    expect(repository.isCacheStale(), isTrue);
    verify(() => mockLocal.isCacheStale()).called(1);
  });
}
