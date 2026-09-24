class CatFact {
  const CatFact({
    required this.fact,
    required this.length,
    this.factEs,
  });

  final String fact;
  final int length;
  final String? factEs;

  String localized(bool isSpanish) {
    if (isSpanish && factEs != null && factEs!.isNotEmpty) {
      return factEs!;
    }
    return fact;
  }

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
