import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/breeds_response_model.dart';

abstract class BreedRemoteDatasource {
  Future<BreedsResponseModel> getBreeds({int page = 1});
}

class BreedRemoteDatasourceImpl implements BreedRemoteDatasource {
  BreedRemoteDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<BreedsResponseModel> getBreeds({int page = 1}) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/breeds',
        queryParameters: {'page': page},
      );
      return BreedsResponseModel.fromJson(response.data!);
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
