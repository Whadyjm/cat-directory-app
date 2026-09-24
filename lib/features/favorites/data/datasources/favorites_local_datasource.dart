import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../../../breeds/data/models/breed_model.dart';

abstract class FavoritesLocalDatasource {
  List<BreedModel> getFavorites();
  Future<void> saveFavorite(BreedModel breed);
  Future<void> removeFavorite(String breedName);
  bool isFavorite(String breedName);
}

class FavoritesLocalDatasourceImpl implements FavoritesLocalDatasource {
  FavoritesLocalDatasourceImpl({required this.box});

  final Box<dynamic> box;

  @override
  List<BreedModel> getFavorites() {
    try {
      final list = <BreedModel>[];
      for (final key in box.keys) {
        final raw = box.get(key);
        if (raw is String) {
          final decoded = jsonDecode(raw) as Map<String, dynamic>;
          list.add(BreedModel.fromJson(decoded));
        } else if (raw is Map) {
          list.add(BreedModel.fromJson(Map<String, dynamic>.from(raw)));
        }
      }
      return list;
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> saveFavorite(BreedModel breed) async {
    try {
      await box.put(breed.breed, jsonEncode(breed.toJson()));
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> removeFavorite(String breedName) async {
    try {
      await box.delete(breedName);
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  bool isFavorite(String breedName) {
    return box.containsKey(breedName);
  }
}
