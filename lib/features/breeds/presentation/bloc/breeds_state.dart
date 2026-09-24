import '../../domain/entities/breed.dart';
import '../../../../core/error/failures.dart';

class BreedsState {
  const BreedsState({
    this.allBreeds = const [],
    this.filteredBreeds = const [],
    this.currentPage = 0,
    this.hasNextPage = true,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.isFromCache = false,
    this.failure,
    this.searchQuery = '',
  });

  final List<Breed> allBreeds;
  final List<Breed> filteredBreeds;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool isFromCache;
  final Failure? failure;
  final String searchQuery;

  bool get hasData => allBreeds.isNotEmpty;
  bool get hasError => failure != null && !hasData;
  bool get hasPaginationError => failure != null && hasData;

  BreedsState copyWith({
    List<Breed>? allBreeds,
    List<Breed>? filteredBreeds,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? isFromCache,
    Failure? failure,
    bool clearFailure = false,
    String? searchQuery,
  }) {
    return BreedsState(
      allBreeds: allBreeds ?? this.allBreeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFromCache: isFromCache ?? this.isFromCache,
      failure: clearFailure ? null : (failure ?? this.failure),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
