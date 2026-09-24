import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/core/localization/app_language.dart';
import 'package:cat_directory_app/core/localization/language_cubit.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
  });

  test('initial state defaults to Spanish when box has no preference', () {
    when(() => mockBox.get('app_language')).thenReturn(null);

    final cubit = LanguageCubit(box: mockBox);

    expect(cubit.state, equals(AppLanguage.es));
    cubit.close();
  });

  test('initial state loads saved English from box', () {
    when(() => mockBox.get('app_language')).thenReturn('en');

    final cubit = LanguageCubit(box: mockBox);

    expect(cubit.state, equals(AppLanguage.en));
    cubit.close();
  });

  test('setLanguage updates state and persists in box', () async {
    when(() => mockBox.get('app_language')).thenReturn(null);
    when(() => mockBox.put('app_language', any())).thenAnswer((_) async {});

    final cubit = LanguageCubit(box: mockBox);
    await cubit.setLanguage(AppLanguage.en);

    expect(cubit.state, equals(AppLanguage.en));
    verify(() => mockBox.put('app_language', 'en')).called(1);
    cubit.close();
  });

  test('toggleLanguage toggles from Spanish to English', () async {
    when(() => mockBox.get('app_language')).thenReturn(null);
    when(() => mockBox.put('app_language', any())).thenAnswer((_) async {});

    final cubit = LanguageCubit(box: mockBox);
    await cubit.toggleLanguage();

    expect(cubit.state, equals(AppLanguage.en));
    verify(() => mockBox.put('app_language', 'en')).called(1);
    cubit.close();
  });
}
