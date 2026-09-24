class Breed {
  const Breed({
    required this.breed,
    required this.country,
    required this.origin,
    required this.coat,
    required this.pattern,
  });

  final String breed;
  final String country;
  final String origin;
  final String coat;
  final String pattern;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Breed &&
          runtimeType == other.runtimeType &&
          breed == other.breed &&
          country == other.country;

  @override
  int get hashCode => breed.hashCode ^ country.hashCode;
}
