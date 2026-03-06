import 'package:dio/dio.dart';

import '../../domain/utils/app_endpoints.dart';
import '../models/signup_resp_model.dart';
import '../utils/ConstantFunc.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponse> login(Map<String, dynamic> data);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<RegisterResponse> login(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        AppEndpoints.login,
        data: {
          'email': data['email'],
          'password': data['password'],
        },
      );
      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(ConstantFunc.extractError(e));
    }
  }
}
