import 'package:hive_ce_flutter/hive_flutter.dart';

import '../localization/language_cubit.dart';
import '../network/dio_client.dart';
import '../theme/theme_cubit.dart';
import '../../features/breeds/data/datasources/breed_local_datasource.dart';
import '../../features/breeds/data/datasources/breed_remote_datasource.dart';
import '../../features/breeds/data/repositories/breeds_repository_impl.dart';
import '../../features/breeds/domain/usecases/get_breeds_usecase.dart';
import '../../features/cat_fact/data/datasources/cat_fact_remote_datasource.dart';
import '../../features/cat_fact/data/datasources/cat_fact_translation_datasource.dart';
import '../../features/cat_fact/data/repositories/cat_fact_repository_impl.dart';
import '../../features/cat_fact/domain/usecases/get_random_fact_usecase.dart';
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';

class AppInjector {
  AppInjector._();

  static late final GetBreedsUsecase breedsUsecase;
  static late final GetRandomFactUsecase getRandomFactUsecase;
  static late final ThemeCubit themeCubit;
  static late final LanguageCubit languageCubit;
  static late final FavoritesCubit favoritesCubit;

  static Future<void> init() async {
    await Hive.initFlutter();
    final breedsBox = await Hive.openBox<dynamic>('breeds_cache');
    final settingsBox = await Hive.openBox<dynamic>('settings_cache');
    final favoritesBox = await Hive.openBox<dynamic>('favorites_cache');

    themeCubit = ThemeCubit(box: settingsBox);
    languageCubit = LanguageCubit(box: settingsBox);

    final favoritesDatasource = FavoritesLocalDatasourceImpl(box: favoritesBox);
    final favoritesRepository = FavoritesRepositoryImpl(localDatasource: favoritesDatasource);
    final getFavoritesUsecase = GetFavoritesUsecase(repository: favoritesRepository);
    final toggleFavoriteUsecase = ToggleFavoriteUsecase(repository: favoritesRepository);
    favoritesCubit = FavoritesCubit(
      getFavoritesUsecase: getFavoritesUsecase,
      toggleFavoriteUsecase: toggleFavoriteUsecase,
    );

    final dioClient = DioClient();
    final remote = BreedRemoteDatasourceImpl(dio: dioClient.dio);
    final local = BreedLocalDatasourceImpl(box: breedsBox);
    final repository = BreedsRepositoryImpl(remote: remote, local: local);
    breedsUsecase = GetBreedsUsecase(repository: repository);

    final catFactRemote = CatFactRemoteDatasourceImpl(dio: dioClient.dio);
    final catFactTranslator = CatFactTranslationDatasourceImpl(dio: dioClient.dio);
    final catFactRepository = CatFactRepositoryImpl(
      remote: catFactRemote,
      translator: catFactTranslator,
    );
    getRandomFactUsecase = GetRandomFactUsecase(repository: catFactRepository);
  }
}
