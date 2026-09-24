import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/app_injector.dart';
import 'core/localization/language_cubit.dart';
import 'core/theme/theme_cubit.dart';
import 'features/breeds/presentation/bloc/breeds_bloc.dart';
import 'features/breeds/presentation/bloc/breeds_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjector.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BreedsBloc(usecase: AppInjector.breedsUsecase)
            ..add(const LoadBreeds()),
        ),
        BlocProvider<ThemeCubit>.value(
          value: AppInjector.themeCubit,
        ),
        BlocProvider<LanguageCubit>.value(
          value: AppInjector.languageCubit,
        ),
      ],
      child: const CatDirectoryApp(),
    ),
  );
}
