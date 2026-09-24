class CatFact {
  const CatFact({
    required this.fact,
    required this.length,
  });

  final String fact;
  final int length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatFact &&
          runtimeType == other.runtimeType &&
          fact == other.fact &&
          length == other.length;

  @override
  int get hashCode => fact.hashCode ^ length.hashCode;
}
