import '../../domain/entities/cat_fact.dart';

sealed class CatFactState {
  const CatFactState();
}

final class CatFactInitial extends CatFactState {
  const CatFactInitial();
}

final class CatFactLoading extends CatFactState {
  const CatFactLoading();
}

final class CatFactLoaded extends CatFactState {
  const CatFactLoaded({required this.fact});

  final CatFact fact;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatFactLoaded &&
          runtimeType == other.runtimeType &&
          fact == other.fact;

  @override
  int get hashCode => fact.hashCode;
}

final class CatFactError extends CatFactState {
  const CatFactError({required this.message});

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatFactError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
