import '../../domain/entities/cat_fact.dart';

class CatFactModel {
  const CatFactModel({
    required this.fact,
    required this.length,
  });

  final String fact;
  final int length;

  factory CatFactModel.fromJson(Map<String, dynamic> json) {
    return CatFactModel(
      fact: json['fact'] as String? ?? '',
      length: (json['length'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'fact': fact,
        'length': length,
      };

  CatFact toEntity() => CatFact(
        fact: fact,
        length: length,
      );
}
