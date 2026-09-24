// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeds_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreedsResponseModelImpl _$$BreedsResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$BreedsResponseModelImpl(
  currentPage: (json['current_page'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => BreedModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  lastPage: (json['last_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$$BreedsResponseModelImplToJson(
  _$BreedsResponseModelImpl instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'data': instance.data,
  'last_page': instance.lastPage,
  'total': instance.total,
};
