// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breeds_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BreedsResponseModel _$BreedsResponseModelFromJson(Map<String, dynamic> json) {
  return _BreedsResponseModel.fromJson(json);
}

/// @nodoc
mixin _$BreedsResponseModel {
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  List<BreedModel> get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page')
  int get lastPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this BreedsResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreedsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedsResponseModelCopyWith<BreedsResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedsResponseModelCopyWith<$Res> {
  factory $BreedsResponseModelCopyWith(
    BreedsResponseModel value,
    $Res Function(BreedsResponseModel) then,
  ) = _$BreedsResponseModelCopyWithImpl<$Res, BreedsResponseModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'current_page') int currentPage,
    List<BreedModel> data,
    @JsonKey(name: 'last_page') int lastPage,
    int total,
  });
}

/// @nodoc
class _$BreedsResponseModelCopyWithImpl<$Res, $Val extends BreedsResponseModel>
    implements $BreedsResponseModelCopyWith<$Res> {
  _$BreedsResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreedsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? data = null,
    Object? lastPage = null,
    Object? total = null,
  }) {
    return _then(
      _value.copyWith(
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<BreedModel>,
            lastPage: null == lastPage
                ? _value.lastPage
                : lastPage // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreedsResponseModelImplCopyWith<$Res>
    implements $BreedsResponseModelCopyWith<$Res> {
  factory _$$BreedsResponseModelImplCopyWith(
    _$BreedsResponseModelImpl value,
    $Res Function(_$BreedsResponseModelImpl) then,
  ) = __$$BreedsResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'current_page') int currentPage,
    List<BreedModel> data,
    @JsonKey(name: 'last_page') int lastPage,
    int total,
  });
}

/// @nodoc
class __$$BreedsResponseModelImplCopyWithImpl<$Res>
    extends _$BreedsResponseModelCopyWithImpl<$Res, _$BreedsResponseModelImpl>
    implements _$$BreedsResponseModelImplCopyWith<$Res> {
  __$$BreedsResponseModelImplCopyWithImpl(
    _$BreedsResponseModelImpl _value,
    $Res Function(_$BreedsResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreedsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? data = null,
    Object? lastPage = null,
    Object? total = null,
  }) {
    return _then(
      _$BreedsResponseModelImpl(
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<BreedModel>,
        lastPage: null == lastPage
            ? _value.lastPage
            : lastPage // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreedsResponseModelImpl implements _BreedsResponseModel {
  const _$BreedsResponseModelImpl({
    @JsonKey(name: 'current_page') required this.currentPage,
    required final List<BreedModel> data,
    @JsonKey(name: 'last_page') required this.lastPage,
    required this.total,
  }) : _data = data;

  factory _$BreedsResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreedsResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  final List<BreedModel> _data;
  @override
  List<BreedModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey(name: 'last_page')
  final int lastPage;
  @override
  final int total;

  @override
  String toString() {
    return 'BreedsResponseModel(currentPage: $currentPage, data: $data, lastPage: $lastPage, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedsResponseModelImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPage,
    const DeepCollectionEquality().hash(_data),
    lastPage,
    total,
  );

  /// Create a copy of BreedsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedsResponseModelImplCopyWith<_$BreedsResponseModelImpl> get copyWith =>
      __$$BreedsResponseModelImplCopyWithImpl<_$BreedsResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BreedsResponseModelImplToJson(this);
  }
}

abstract class _BreedsResponseModel implements BreedsResponseModel {
  const factory _BreedsResponseModel({
    @JsonKey(name: 'current_page') required final int currentPage,
    required final List<BreedModel> data,
    @JsonKey(name: 'last_page') required final int lastPage,
    required final int total,
  }) = _$BreedsResponseModelImpl;

  factory _BreedsResponseModel.fromJson(Map<String, dynamic> json) =
      _$BreedsResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  List<BreedModel> get data;
  @override
  @JsonKey(name: 'last_page')
  int get lastPage;
  @override
  int get total;

  /// Create a copy of BreedsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedsResponseModelImplCopyWith<_$BreedsResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
