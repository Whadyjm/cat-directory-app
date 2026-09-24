import 'breed.dart';

class BreedsPageResult {
  const BreedsPageResult({
    required this.breeds,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<Breed> breeds;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasNextPage => currentPage < lastPage;
}
