import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_directory_app/core/theme/theme_cubit.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
  });

  test('initial state is ThemeMode.system when box has no saved preference', () {
    when(() => mockBox.get('app_theme_mode')).thenReturn(null);

    final cubit = ThemeCubit(box: mockBox);

    expect(cubit.state, equals(ThemeMode.system));
    cubit.close();
  });

  test('initial state loads saved preference from box', () {
    when(() => mockBox.get('app_theme_mode')).thenReturn('dark');

    final cubit = ThemeCubit(box: mockBox);

    expect(cubit.state, equals(ThemeMode.dark));
    cubit.close();
  });

  test('setThemeMode updates state and persists in box', () async {
    when(() => mockBox.get('app_theme_mode')).thenReturn(null);
    when(() => mockBox.put('app_theme_mode', any())).thenAnswer((_) async {});

    final cubit = ThemeCubit(box: mockBox);
    await cubit.setThemeMode(ThemeMode.light);

    expect(cubit.state, equals(ThemeMode.light));
    verify(() => mockBox.put('app_theme_mode', 'light')).called(1);
    cubit.close();
  });

  test('toggleTheme cycles correctly from system to light', () async {
    when(() => mockBox.get('app_theme_mode')).thenReturn(null);
    when(() => mockBox.put('app_theme_mode', any())).thenAnswer((_) async {});

    final cubit = ThemeCubit(box: mockBox);
    await cubit.toggleTheme();

    expect(cubit.state, equals(ThemeMode.light));
    verify(() => mockBox.put('app_theme_mode', 'light')).called(1);
    cubit.close();
  });
}
