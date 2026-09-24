import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/app_injector.dart';
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
      ],
      child: const CatDirectoryApp(),
    ),
  );
}
