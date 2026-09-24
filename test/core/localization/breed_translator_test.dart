import 'package:flutter_test/flutter_test.dart';

import 'package:cat_directory_app/core/localization/app_language.dart';
import 'package:cat_directory_app/core/localization/breed_translator.dart';
import 'package:cat_directory_app/features/breeds/domain/entities/breed.dart';

void main() {
  const tBreedEn = Breed(
    breed: 'Abyssinian',
    country: 'Egypt',
    origin: 'Natural',
    coat: 'Short',
    pattern: 'Ticked',
  );

  test('translates country to Spanish correctly', () {
    expect(BreedTranslator.translateCountry('Egypt', AppLanguage.es), equals('Egipto'));
    expect(BreedTranslator.translateCountry('United States', AppLanguage.es), equals('Estados Unidos'));
  });

  test('returns original country when English is selected', () {
    expect(BreedTranslator.translateCountry('Egypt', AppLanguage.en), equals('Egypt'));
  });

  test('translates all breed attributes when Spanish is selected', () {
    final translated = BreedTranslator.translateBreed(tBreedEn, AppLanguage.es);

    expect(translated.country, equals('Egipto'));
    expect(translated.origin, equals('Natural'));
    expect(translated.coat, equals('Corto'));
    expect(translated.pattern, equals('Jaspeado (Ticked)'));
    expect(translated.breed, equals('Abyssinian'));
  });

  test('keeps English attributes when English is selected', () {
    final translated = BreedTranslator.translateBreed(tBreedEn, AppLanguage.en);

    expect(translated.country, equals('Egypt'));
    expect(translated.origin, equals('Natural'));
    expect(translated.coat, equals('Short'));
    expect(translated.pattern, equals('Ticked'));
  });
}
