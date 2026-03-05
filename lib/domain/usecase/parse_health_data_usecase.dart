import 'package:RoseAI/domain/repository/auth_repository.dart';

class ParseHealthDataUseCase{
  final AuthRepository  repository;

  ParseHealthDataUseCase(this.repository);

  Future<dynamic> call(Map<String,dynamic>data){
    return repository.parseHealthData(data);
  }
}