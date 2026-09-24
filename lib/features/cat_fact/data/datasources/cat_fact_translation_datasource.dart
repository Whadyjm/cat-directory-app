import 'package:dio/dio.dart';

abstract class CatFactTranslationDatasource {
  Future<String?> translateToSpanish(String text);
}

class CatFactTranslationDatasourceImpl implements CatFactTranslationDatasource {
  const CatFactTranslationDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<String?> translateToSpanish(String text) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://api.mymemory.translated.net/get',
        queryParameters: {
          'q': text,
          'langpair': 'en|es',
        },
      );
      final data = response.data;
      if (data != null && data['responseData'] is Map<String, dynamic>) {
        final responseData = data['responseData'] as Map<String, dynamic>;
        final translated = responseData['translatedText'] as String?;
        if (translated != null && translated.trim().isNotEmpty) {
          return translated.trim();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
