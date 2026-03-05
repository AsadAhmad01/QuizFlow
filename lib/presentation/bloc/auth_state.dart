import 'package:RoseAI/data/models/signup_resp_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final RegisterResponse user;

  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class PasswordResetMessage extends AuthState {
  final String message;
  final bool success;

  PasswordResetMessage(this.message, this.success);
}
