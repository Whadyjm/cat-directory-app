import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../models/breeds_response_model.dart';

abstract class BreedLocalDatasource {
  Future<BreedsResponseModel?> getCachedFirstPage();
  Future<void> cacheFirstPage(BreedsResponseModel response);
  bool isCacheStale();
}

class BreedLocalDatasourceImpl implements BreedLocalDatasource {
  BreedLocalDatasourceImpl({required this.box});

  final Box<dynamic> box;

  static const String _breedsKey = 'cached_breeds_page_1';
  static const String _timestampKey = 'cache_timestamp';
  static const Duration _ttl = Duration(minutes: 30);

  @override
  Future<BreedsResponseModel?> getCachedFirstPage() async {
    try {
      final json = box.get(_breedsKey) as String?;
      if (json == null) return null;
      return BreedsResponseModel.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheFirstPage(BreedsResponseModel response) async {
    try {
      await box.put(_breedsKey, jsonEncode(response.toJson()));
      await box.put(
        _timestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  bool isCacheStale() {
    final timestamp = box.get(_timestampKey) as int?;
    if (timestamp == null) return true;
    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    return age > _ttl.inMilliseconds;
  }
}
