sealed class BreedsEvent {
  const BreedsEvent();
}

final class LoadBreeds extends BreedsEvent {
  const LoadBreeds();
}

final class LoadMoreBreeds extends BreedsEvent {
  const LoadMoreBreeds();
}

final class RefreshBreeds extends BreedsEvent {
  const RefreshBreeds();
}

final class SearchBreeds extends BreedsEvent {
  const SearchBreeds(this.query);
  final String query;
}
