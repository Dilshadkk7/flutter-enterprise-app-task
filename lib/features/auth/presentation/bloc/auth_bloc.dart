import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/auth/domain/usecases/login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;

  AuthBloc({required this.login}) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrSuccess = await login(
      LoginParams(email: event.email, password: event.password),
    );
    failureOrSuccess.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (_) => emit(AuthSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error. Please try again.';
      case NetworkFailure:
        return 'No Internet Connection.';
      default:
        return 'Unexpected Error';
    }
  }
}
