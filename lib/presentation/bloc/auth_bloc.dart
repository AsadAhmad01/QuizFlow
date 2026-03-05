import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/LoginUser_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;

  AuthBloc({required this.loginUser}) : super(AuthInitial()) {
    on<LoginRequested>(_handleLogin);
    on<SignupRequested>(_handleSignup);
    on<ForgotPasswordRequested>(_handleForgotPassword);
  }

  Future<void> _handleLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await loginUser(event.data);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _handleSignup(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      /*   final user = await signupUser(
        event.email,
        event.password,
        event.fullName,
        event.phoneNumber,
      );
      emit(AuthSuccess(user));*/
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _handleForgotPassword(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      /*     final UserModel<Data> user = await forgotPassword(event.email);
      emit(PasswordResetMessage(user.message, user.success));*/
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
