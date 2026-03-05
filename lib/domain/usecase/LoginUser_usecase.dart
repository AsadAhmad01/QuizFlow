import '../repository/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<dynamic> call(Map<String, dynamic> data) {
    return repository.login(data);
  }
}