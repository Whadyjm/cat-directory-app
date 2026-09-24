import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/features/breeds/data/models/breed_model.dart';
import 'package:cat_directory_app/features/favorites/data/datasources/favorites_local_datasource.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox mockBox;
  late FavoritesLocalDatasourceImpl datasource;

  const testBreed = BreedModel(
    breed: 'Abyssinian',
    country: 'Egypt',
    origin: 'Natural/Standard',
    coat: 'Short',
    pattern: 'Ticked',
  );

  setUp(() {
    mockBox = MockBox();
    datasource = FavoritesLocalDatasourceImpl(box: mockBox);
  });

  test('getFavorites returns empty list when box has no keys', () {
    when(() => mockBox.keys).thenReturn([]);

    final result = datasource.getFavorites();

    expect(result, isEmpty);
  });

  test('getFavorites returns parsed list of BreedModel', () {
    when(() => mockBox.keys).thenReturn(['Abyssinian']);
    when(() => mockBox.get('Abyssinian'))
        .thenReturn(jsonEncode(testBreed.toJson()));

    final result = datasource.getFavorites();

    expect(result.length, equals(1));
    expect(result.first.breed, equals('Abyssinian'));
    expect(result.first.country, equals('Egypt'));
  });

  test('saveFavorite writes json string to box', () async {
    when(() => mockBox.put('Abyssinian', any())).thenAnswer((_) async {});

    await datasource.saveFavorite(testBreed);

    verify(() => mockBox.put('Abyssinian', any())).called(1);
  });

  test('removeFavorite deletes key from box', () async {
    when(() => mockBox.delete('Abyssinian')).thenAnswer((_) async {});

    await datasource.removeFavorite('Abyssinian');

    verify(() => mockBox.delete('Abyssinian')).called(1);
  });

  test('isFavorite returns containsKey result from box', () {
    when(() => mockBox.containsKey('Abyssinian')).thenReturn(true);
    when(() => mockBox.containsKey('Persian')).thenReturn(false);

    expect(datasource.isFavorite('Abyssinian'), isTrue);
    expect(datasource.isFavorite('Persian'), isFalse);
  });
}
