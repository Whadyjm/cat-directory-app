import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/features/breeds/data/models/breed_model.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:cat_directory_app/features/favorites/data/repositories/favorites_repository_impl.dart';

class MockFavoritesLocalDatasource extends Mock
    implements FavoritesLocalDatasource {}

void main() {
  late MockFavoritesLocalDatasource mockDatasource;
  late FavoritesRepositoryImpl repository;

  const testEntity = Breed(
    breed: 'Abyssinian',
    country: 'Egypt',
    origin: 'Natural/Standard',
    coat: 'Short',
    pattern: 'Ticked',
  );

  const testModel = BreedModel(
    breed: 'Abyssinian',
    country: 'Egypt',
    origin: 'Natural/Standard',
    coat: 'Short',
    pattern: 'Ticked',
  );

  setUp(() {
    mockDatasource = MockFavoritesLocalDatasource();
    repository = FavoritesRepositoryImpl(localDatasource: mockDatasource);
  });

  setUpAll(() {
    registerFallbackValue(testModel);
  });

  test('getFavorites maps datasource models to domain entities', () {
    when(() => mockDatasource.getFavorites()).thenReturn([testModel]);

    final result = repository.getFavorites();

    expect(result.length, equals(1));
    expect(result.first.breed, equals('Abyssinian'));
    expect(result.first.country, equals('Egypt'));
  });

  test('toggleFavorite removes breed when already favorite', () async {
    when(() => mockDatasource.isFavorite('Abyssinian')).thenReturn(true);
    when(() => mockDatasource.removeFavorite('Abyssinian'))
        .thenAnswer((_) async {});

    await repository.toggleFavorite(testEntity);

    verify(() => mockDatasource.removeFavorite('Abyssinian')).called(1);
    verifyNever(() => mockDatasource.saveFavorite(any()));
  });

  test('toggleFavorite saves breed when not yet favorite', () async {
    when(() => mockDatasource.isFavorite('Abyssinian')).thenReturn(false);
    when(() => mockDatasource.saveFavorite(any())).thenAnswer((_) async {});

    await repository.toggleFavorite(testEntity);

    verify(() => mockDatasource.saveFavorite(any())).called(1);
    verifyNever(() => mockDatasource.removeFavorite(any()));
  });

  test('isFavorite delegates to datasource', () {
    when(() => mockDatasource.isFavorite('Abyssinian')).thenReturn(true);

    expect(repository.isFavorite('Abyssinian'), isTrue);
    verify(() => mockDatasource.isFavorite('Abyssinian')).called(1);
  });
}
