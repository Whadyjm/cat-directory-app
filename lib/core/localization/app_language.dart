enum AppLanguage {
  es,
  en;

  bool get isSpanish => this == AppLanguage.es;
  bool get isEnglish => this == AppLanguage.en;
  String get code => name.toUpperCase();
}
