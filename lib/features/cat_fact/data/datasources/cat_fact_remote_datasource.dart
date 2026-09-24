import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/cat_fact_model.dart';

abstract class CatFactRemoteDatasource {
  Future<CatFactModel> getRandomFact();
}

class CatFactRemoteDatasourceImpl implements CatFactRemoteDatasource {
  const CatFactRemoteDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<CatFactModel> getRandomFact() async {
    try {
      final response = await dio.get<Map<String, dynamic>>('/fact');
      if (response.data == null) {
        throw const ServerException('Respuesta vacía del servidor.');
      }
      return CatFactModel.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw const NetworkException();
      }
      throw ServerException(
        e.response?.statusMessage ?? 'Server error (${e.response?.statusCode})',
      );
    }
  }
}
