import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({required Box<dynamic> box})
      : _box = box,
        super(_loadThemeMode(box));

  final Box<dynamic> _box;
  static const String _key = 'app_theme_mode';

  static ThemeMode _loadThemeMode(Box<dynamic> box) {
    final saved = box.get(_key) as String?;
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    await _box.put(_key, mode.name);
  }

  Future<void> toggleTheme() async {
    final next = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(next);
  }
}
