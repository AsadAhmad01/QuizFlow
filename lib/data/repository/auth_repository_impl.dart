import 'dart:io';

import 'package:RoseAI/data/datasources/auth_remote_data_source.dart';
import 'package:RoseAI/data/models/user_model.dart';

import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  late final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<dynamic> login(Map<String, dynamic> data) async {
    return remoteDataSource.login(data);
  }

  @override
  Future<dynamic> signup(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) async {
    return remoteDataSource.signup(fullName, email, password, phoneNumber);
  }

  @override
  Future<dynamic> forgotPassword(String email) async {
    return remoteDataSource.forgotPassword(email);
  }

  @override
  Future<dynamic> forgotPasswordOtpVerify(String email, String otp) async {
    return remoteDataSource.forgotPassOtpVerify(email, otp);
  }

  @override
  Future<dynamic> newPasswordUpdate(String email, String newPass) async {
    return remoteDataSource.newPassUpdate(email, newPass);
  }

  @override
  Future logout() async {
    return remoteDataSource.logout();
  }

  @override
  Future refreshToken() {
    return remoteDataSource.refreshToken();
  }

  @override
  Future<dynamic> passwordUpdate(String currentPassword, String newPassword) {
    return remoteDataSource.passUpdate(currentPassword, newPassword);
  }

  @override
  Future updateProfile(String fullName, File? imagePath) {
    return remoteDataSource.updateProfile(fullName, imagePath);
  }

  @override
  Future<UserModel> deleteAccount() {
    return remoteDataSource.deleteAccount();
  }

  @override
  Future<void> resendOTP(String email) {
    return remoteDataSource.resendOTP(email);
  }

  @override
  Future<void> verifyOTP(String email, String otp) {
    return remoteDataSource.verifyOTP(email, otp);
  }

  @override
  Future parseHealthData(Map<String, dynamic> data) {
    return remoteDataSource.parseHealthData(data);
  }
}
