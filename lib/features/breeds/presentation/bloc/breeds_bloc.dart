import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/breed.dart';
import '../../domain/usecases/get_breeds_usecase.dart';
import 'breeds_event.dart';
import 'breeds_state.dart';

EventTransformer<T> _debounce<T>(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);

class BreedsBloc extends Bloc<BreedsEvent, BreedsState> {
  BreedsBloc({required this.usecase}) : super(const BreedsState()) {
    on<LoadBreeds>(_onLoadBreeds);
    on<LoadMoreBreeds>(_onLoadMoreBreeds, transformer: droppable());
    on<RefreshBreeds>(_onRefreshBreeds);
    on<SearchBreeds>(
      _onSearchBreeds,
      transformer: _debounce(const Duration(milliseconds: 350)),
    );
    on<FilterByCoat>(_onFilterByCoat);
  }

  final GetBreedsUsecase usecase;

  Future<void> _onLoadBreeds(
    LoadBreeds event,
    Emitter<BreedsState> emit,
  ) async {
    emit(state.copyWith(isLoadingInitial: true, clearFailure: true));

    final cached = await usecase.getCached();
    if (cached != null) {
      emit(state.copyWith(
        allBreeds: cached.breeds,
        filteredBreeds: _filterBreeds(cached.breeds, state.searchQuery, state.selectedCoat),
        currentPage: cached.currentPage,
        hasNextPage: cached.hasNextPage,
        isLoadingInitial: false,
        isFromCache: true,
      ));
    }

    try {
      final result = await usecase.call(page: 1);
      emit(state.copyWith(
        allBreeds: result.breeds,
        filteredBreeds: _filterBreeds(result.breeds, state.searchQuery, state.selectedCoat),
        currentPage: result.currentPage,
        hasNextPage: result.hasNextPage,
        isLoadingInitial: false,
        isFromCache: false,
        clearFailure: true,
      ));
    } on Failure catch (e) {
      if (!state.hasData) {
        emit(state.copyWith(isLoadingInitial: false, failure: e));
      }
    } catch (_) {
      if (!state.hasData) {
        emit(state.copyWith(
          isLoadingInitial: false,
          failure: const ServerFailure(),
        ));
      }
    }
  }

  Future<void> _onLoadMoreBreeds(
    LoadMoreBreeds event,
    Emitter<BreedsState> emit,
  ) async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, clearFailure: true));

    try {
      final result = await usecase.call(page: state.currentPage + 1);
      final merged = [...state.allBreeds, ...result.breeds];
      emit(state.copyWith(
        allBreeds: merged,
        filteredBreeds: _filterBreeds(merged, state.searchQuery, state.selectedCoat),
        currentPage: result.currentPage,
        hasNextPage: result.hasNextPage,
        isLoadingMore: false,
        clearFailure: true,
      ));
    } on Failure catch (e) {
      emit(state.copyWith(isLoadingMore: false, failure: e));
    } catch (_) {
      emit(state.copyWith(
        isLoadingMore: false,
        failure: const ServerFailure(),
      ));
    }
  }

  Future<void> _onRefreshBreeds(
    RefreshBreeds event,
    Emitter<BreedsState> emit,
  ) async {
    emit(state.copyWith(
      isRefreshing: true,
      clearFailure: true,
      searchQuery: '',
      selectedCoat: 'All',
    ));

    try {
      final result = await usecase.call(page: 1);
      emit(state.copyWith(
        allBreeds: result.breeds,
        filteredBreeds: result.breeds,
        currentPage: result.currentPage,
        hasNextPage: result.hasNextPage,
        isRefreshing: false,
        isFromCache: false,
        clearFailure: true,
        searchQuery: '',
        selectedCoat: 'All',
      ));
    } on Failure catch (e) {
      emit(state.copyWith(isRefreshing: false, failure: e));
    } catch (_) {
      emit(state.copyWith(
        isRefreshing: false,
        failure: const ServerFailure(),
      ));
    }
  }

  void _onSearchBreeds(
    SearchBreeds event,
    Emitter<BreedsState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    emit(state.copyWith(
      searchQuery: query,
      filteredBreeds: _filterBreeds(state.allBreeds, query, state.selectedCoat),
    ));
  }

  void _onFilterByCoat(
    FilterByCoat event,
    Emitter<BreedsState> emit,
  ) {
    emit(state.copyWith(
      selectedCoat: event.coat,
      filteredBreeds: _filterBreeds(state.allBreeds, state.searchQuery, event.coat),
    ));
  }

  List<Breed> _filterBreeds(List<Breed> breeds, String query, String coat) {
    return breeds.where((b) {
      final matchesQuery = query.isEmpty || b.breed.toLowerCase().contains(query);
      final matchesCoat = coat == 'All' ||
          coat == 'Favorites' ||
          b.coat.toLowerCase().contains(coat.toLowerCase());
      return matchesQuery && matchesCoat;
    }).toList();
  }
}
