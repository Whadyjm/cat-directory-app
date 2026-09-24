import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../breeds/domain/entities/breed.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required this.getFavoritesUsecase,
    required this.toggleFavoriteUsecase,
  }) : super(const FavoritesState()) {
    loadFavorites();
  }

  final GetFavoritesUsecase getFavoritesUsecase;
  final ToggleFavoriteUsecase toggleFavoriteUsecase;

  void loadFavorites() {
    final list = getFavoritesUsecase();
    final names = list.map((b) => b.breed).toSet();
    emit(FavoritesState(favoriteBreeds: list, favoriteNames: names));
  }

  Future<void> toggleFavorite(Breed breed) async {
    await toggleFavoriteUsecase(breed);
    loadFavorites();
  }
}
