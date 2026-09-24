import 'package:freezed_annotation/freezed_annotation.dart';

import 'breed_model.dart';

part 'breeds_response_model.freezed.dart';
part 'breeds_response_model.g.dart';

@freezed
class BreedsResponseModel with _$BreedsResponseModel {
  const factory BreedsResponseModel({
    @JsonKey(name: 'current_page') required int currentPage,
    required List<BreedModel> data,
    @JsonKey(name: 'last_page') required int lastPage,
    required int total,
  }) = _BreedsResponseModel;

  factory BreedsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BreedsResponseModelFromJson(json);
}
