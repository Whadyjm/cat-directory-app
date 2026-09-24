import '../../../breeds/domain/entities/breed.dart';

class FavoritesState {
  const FavoritesState({
    this.favoriteBreeds = const [],
    this.favoriteNames = const {},
  });

  final List<Breed> favoriteBreeds;
  final Set<String> favoriteNames;

  bool isFavorite(String breedName) => favoriteNames.contains(breedName);

  FavoritesState copyWith({
    List<Breed>? favoriteBreeds,
    Set<String>? favoriteNames,
  }) {
    return FavoritesState(
      favoriteBreeds: favoriteBreeds ?? this.favoriteBreeds,
      favoriteNames: favoriteNames ?? this.favoriteNames,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesState &&
          favoriteNames.length == other.favoriteNames.length &&
          favoriteNames.containsAll(other.favoriteNames);

  @override
  int get hashCode => favoriteNames.hashCode;
}
