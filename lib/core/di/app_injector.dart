import 'package:hive_ce_flutter/hive_flutter.dart';

import '../network/dio_client.dart';
import '../../features/breeds/data/datasources/breed_local_datasource.dart';
import '../../features/breeds/data/datasources/breed_remote_datasource.dart';
import '../../features/breeds/data/repositories/breeds_repository_impl.dart';
import '../../features/breeds/domain/usecases/get_breeds_usecase.dart';

class AppInjector {
  AppInjector._();

  static late final GetBreedsUsecase breedsUsecase;

  static Future<void> init() async {
    await Hive.initFlutter();
    final breedsBox = await Hive.openBox<dynamic>('breeds_cache');

    final dioClient = DioClient();
    final remote = BreedRemoteDatasourceImpl(dio: dioClient.dio);
    final local = BreedLocalDatasourceImpl(box: breedsBox);
    final repository = BreedsRepositoryImpl(remote: remote, local: local);
    breedsUsecase = GetBreedsUsecase(repository: repository);
  }
}
