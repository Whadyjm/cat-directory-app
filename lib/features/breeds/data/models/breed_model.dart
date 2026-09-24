import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/breed.dart';

part 'breed_model.freezed.dart';
part 'breed_model.g.dart';

@freezed
class BreedModel with _$BreedModel {
  const factory BreedModel({
    required String breed,
    required String country,
    required String origin,
    required String coat,
    required String pattern,
  }) = _BreedModel;

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);
}

extension BreedModelX on BreedModel {
  Breed toEntity() => Breed(
        breed: breed,
        country: country,
        origin: origin,
        coat: coat,
        pattern: pattern,
      );
}
