part of 'breed_model.dart';

_$BreedModelImpl _$$BreedModelImplFromJson(Map<String, dynamic> json) =>
    _$BreedModelImpl(
      breed: json['breed'] as String,
      country: json['country'] as String,
      origin: json['origin'] as String,
      coat: json['coat'] as String,
      pattern: json['pattern'] as String,
    );

Map<String, dynamic> _$$BreedModelImplToJson(_$BreedModelImpl instance) =>
    <String, dynamic>{
      'breed': instance.breed,
      'country': instance.country,
      'origin': instance.origin,
      'coat': instance.coat,
      'pattern': instance.pattern,
    };
