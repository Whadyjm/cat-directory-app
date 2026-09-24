import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

import 'app_language.dart';

class LanguageCubit extends Cubit<AppLanguage> {
  LanguageCubit({required Box<dynamic> box})
      : _box = box,
        super(_loadLanguage(box));

  final Box<dynamic> _box;
  static const String _key = 'app_language';

  static AppLanguage _loadLanguage(Box<dynamic> box) {
    final saved = box.get(_key) as String?;
    return saved == 'en' ? AppLanguage.en : AppLanguage.es;
  }

  Future<void> setLanguage(AppLanguage language) async {
    emit(language);
    await _box.put(_key, language.name);
  }

  Future<void> toggleLanguage() async {
    final next = state == AppLanguage.es ? AppLanguage.en : AppLanguage.es;
    await setLanguage(next);
  }
}
