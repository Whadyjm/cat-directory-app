part of 'breeds_response_model.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BreedsResponseModel _$BreedsResponseModelFromJson(Map<String, dynamic> json) {
  return _BreedsResponseModel.fromJson(json);
}

mixin _$BreedsResponseModel {
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  List<BreedModel> get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page')
  int get lastPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedsResponseModelCopyWith<BreedsResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

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

class _$BreedsResponseModelCopyWithImpl<$Res, $Val extends BreedsResponseModel>
    implements $BreedsResponseModelCopyWith<$Res> {
  _$BreedsResponseModelCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

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
                : currentPage
                      as int,
            data: null == data
                ? _value.data
                : data
                      as List<BreedModel>,
            lastPage: null == lastPage
                ? _value.lastPage
                : lastPage
                      as int,
            total: null == total
                ? _value.total
                : total
                      as int,
          )
          as $Val,
    );
  }
}

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

class __$$BreedsResponseModelImplCopyWithImpl<$Res>
    extends _$BreedsResponseModelCopyWithImpl<$Res, _$BreedsResponseModelImpl>
    implements _$$BreedsResponseModelImplCopyWith<$Res> {
  __$$BreedsResponseModelImplCopyWithImpl(
    _$BreedsResponseModelImpl _value,
    $Res Function(_$BreedsResponseModelImpl) _then,
  ) : super(_value, _then);

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
            : currentPage
                  as int,
        data: null == data
            ? _value._data
            : data
                  as List<BreedModel>,
        lastPage: null == lastPage
            ? _value.lastPage
            : lastPage
                  as int,
        total: null == total
            ? _value.total
            : total
                  as int,
      ),
    );
  }
}

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

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedsResponseModelImplCopyWith<_$BreedsResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
