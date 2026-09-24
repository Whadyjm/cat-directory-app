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
        filteredBreeds: cached.breeds,
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
        filteredBreeds: _applySearch(result.breeds, state.searchQuery),
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
        filteredBreeds: _applySearch(merged, state.searchQuery),
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
      filteredBreeds: _applySearch(state.allBreeds, query),
    ));
  }

  List<Breed> _applySearch(List<Breed> breeds, String query) {
    if (query.isEmpty) return breeds;
    return breeds
        .where((b) => b.breed.toLowerCase().contains(query))
        .toList();
  }
}
