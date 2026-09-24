import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_random_fact_usecase.dart';
import 'cat_fact_state.dart';

class CatFactCubit extends Cubit<CatFactState> {
  CatFactCubit({required this.getRandomFactUsecase})
      : super(const CatFactInitial());

  final GetRandomFactUsecase getRandomFactUsecase;

  Future<void> fetchRandomFact() async {
    emit(const CatFactLoading());
    try {
      final fact = await getRandomFactUsecase();
      emit(CatFactLoaded(fact: fact));
    } on Failure catch (e) {
      emit(CatFactError(message: e.message));
    } catch (_) {
      emit(const CatFactError(
        message: 'Error inesperado al cargar el dato curioso.',
      ));
    }
  }
}
