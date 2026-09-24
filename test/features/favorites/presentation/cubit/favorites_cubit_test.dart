import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';
import 'package:cat_directory_app/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:cat_directory_app/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:cat_directory_app/features/favorites/presentation/cubit/favorites_cubit.dart';

class MockGetFavoritesUsecase extends Mock implements GetFavoritesUsecase {}
class MockToggleFavoriteUsecase extends Mock implements ToggleFavoriteUsecase {}

void main() {
  late MockGetFavoritesUsecase mockGetFavorites;
  late MockToggleFavoriteUsecase mockToggleFavorite;

  const testBreed = Breed(
    breed: 'Abyssinian',
    country: 'Egypt',
    origin: 'Natural/Standard',
    coat: 'Short',
    pattern: 'Ticked',
  );

  setUp(() {
    mockGetFavorites = MockGetFavoritesUsecase();
    mockToggleFavorite = MockToggleFavoriteUsecase();
  });

  setUpAll(() {
    registerFallbackValue(testBreed);
  });

  test('initial state loads favorite breeds from usecase', () {
    when(() => mockGetFavorites.call()).thenReturn([testBreed]);

    final cubit = FavoritesCubit(
      getFavoritesUsecase: mockGetFavorites,
      toggleFavoriteUsecase: mockToggleFavorite,
    );

    expect(cubit.state.favoriteBreeds, equals([testBreed]));
    expect(cubit.state.favoriteNames, contains('Abyssinian'));
    expect(cubit.state.isFavorite('Abyssinian'), isTrue);
    expect(cubit.state.isFavorite('Persian'), isFalse);
    cubit.close();
  });

  test('toggleFavorite calls toggle usecase and reloads favorites', () async {
    when(() => mockGetFavorites.call()).thenReturn([]);
    when(() => mockToggleFavorite.call(any())).thenAnswer((_) async {});

    final cubit = FavoritesCubit(
      getFavoritesUsecase: mockGetFavorites,
      toggleFavoriteUsecase: mockToggleFavorite,
    );

    expect(cubit.state.favoriteBreeds, isEmpty);

    when(() => mockGetFavorites.call()).thenReturn([testBreed]);
    await cubit.toggleFavorite(testBreed);

    expect(cubit.state.favoriteBreeds, equals([testBreed]));
    expect(cubit.state.favoriteNames, contains('Abyssinian'));
    verify(() => mockToggleFavorite.call(testBreed)).called(1);
    cubit.close();
  });
}
