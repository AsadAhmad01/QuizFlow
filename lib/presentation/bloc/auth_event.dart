abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final Map<String,dynamic> data;

  LoginRequested(this.data);
}

class SignupRequested extends AuthEvent {
  final String email, password, fullName,phoneNumber;

  SignupRequested(this.email, this.password, this.fullName,this.phoneNumber);
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested(this.email);
}
