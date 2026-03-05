import 'dart:convert';
import 'dart:io';

import 'package:RoseAI/data/models/RefreshTokenResponse.dart';
import 'package:RoseAI/data/models/signup_resp_model.dart';
import 'package:RoseAI/domain/utils/ApiUrls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';
import '../utils/ConstantFunc.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> parseHealthData(Map<String, dynamic> data);

  Future<RegisterResponse> login(Map<String, dynamic> data);

  Future<dynamic> signup(
    String fullName,
    String email,
    String password,
    String phoneNumber,
  );

  Future<void> forgotPassword(String email);

  Future<RegisterResponse> verifyOTP(String email, String otp);

  Future<RegisterResponse> resendOTP(String email);

  Future<UserModel> forgotPassOtpVerify(String email, String otp);

  Future<UserModel> newPassUpdate(String email, String newPass);

  Future<UserModel> passUpdate(String currentPassword, String newPassword);

  Future<UserModel> logout();

  Future<RefreshTokenResponse> refreshToken();

  Future<UserModel> updateProfile(String fullName, File? imagePath);

  Future<UserModel> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<RegisterResponse> login(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        ApiUrls.loginEndpoint,
        data: {
          /* 'fullName': data['fullName'],*/
          'email': data['email'],
          'password': data['password'],
          /*   'fcmToken': "abkcndkjfs2345678",
          'isGoogle': data['isGoogle'],
          'isApple': data['isApple'],
          'isAndroid': data['isAndroid'],*/
        },
      );

      print("API End-Point: ${ApiUrls.loginEndpoint}");
      print("API End-Point: ${data.toString()}");
      print("API End-Point: ${response.toString()}");
      // Parse the response using UserModel
      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<dynamic> signup(
    String fullName,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      // Make the API call
      final response = await dio.post(
        ApiUrls.registerEndpoint,
        data: {
          'userName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );
      print("API End-Point: ${ApiUrls.registerEndpoint}");
      print(
        "API End-Point: ${fullName.toString()}, ${email.toString()}, ${password.toString()}",
      );
      print("API End-Point: ${response.toString()}");

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<UserModel> forgotPassword(String email) async {
    try {
      final response = await dio.post(
        ApiUrls.forgotPassEndpoint,
        data: {'email': email},
      );

      print("API End-Point: ${ApiUrls.forgotPassEndpoint}");
      print("API End-Point: ${email.toString()}");
      print("API End-Point: ${response.toString()}");
      return UserModel<Data>.fromJson(
        response.data,
        (dataJson) => Data.fromJson(dataJson),
      );
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<UserModel> forgotPassOtpVerify(String email, String otp) async {
    try {
      final response = await dio.post(
        ApiUrls.forgotVerifyOtpEndPoint,
        data: {'email': email, "otp": otp},
      );

      print("API End-Point: ${ApiUrls.forgotVerifyOtpEndPoint}");
      print("API End-Point: ${email.toString()}, ${otp.toString()}");
      print("API End-Point: ${response.toString()}");
      return UserModel<Data>.fromJson(
        response.data,
        (dataJson) => Data.fromJson(dataJson),
      );
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<UserModel> newPassUpdate(String email, String newPass) async {
    try {
      final response = await dio.post(
        ApiUrls.addNewPasswordEndPoint,
        data: {'email': email, "newPassword": newPass},
      );

      print("API End-Point: ${ApiUrls.addNewPasswordEndPoint}");
      print("API End-Point: ${email.toString()}, ${newPass.toString()}");
      print("API End-Point: ${response.toString()}");

      return UserModel<Data>.fromJson(
        response.data,
        (dataJson) => Data.fromJson(dataJson),
      );
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<UserModel> logout() async {
    try {
      final response = await dio.get(ApiUrls.logoutEndPoint);

      print("API End-Point: ${ApiUrls.logoutEndPoint}");
      print("API End-Point: ${response.toString()}");
      return UserModel.fromJson(
        response.data,
        (dataJSon) => Data.fromJson(dataJSon),
      );
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<RefreshTokenResponse> refreshToken() async {
    try {
      final response = await dio.get(ApiUrls.refreshTokenEndPoint);

      print("API End-Point: ${ApiUrls.refreshTokenEndPoint}");

      return RefreshTokenResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<UserModel> passUpdate(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await dio.post(
        ApiUrls.updatePasswordEndPoint,
        data: {'currentPassword': currentPassword, "newPassword": newPassword},
      );

      print("API End-Point: ${ApiUrls.updatePasswordEndPoint}");
      print(
        "API End-Point: ${currentPassword.toString()}, ${newPassword.toString()}",
      );
      print("API End-Point: ${response.toString()}");
      return UserModel<Data>.fromJson(
        response.data,
        (dataJson) => Data.fromJson(dataJson),
      );
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<UserModel> updateProfile(String fullName, File? imagePath) async {
    try {
      final Map<String, dynamic> dataMap = {'fullName': fullName};

      if (imagePath != null) {
        dataMap['image'] = await MultipartFile.fromFile(
          imagePath.path,
          filename: 'profile.jpg',
        );
      }

      FormData formData = FormData.fromMap(dataMap);

      final response = await dio.post(
        ApiUrls.updateProfileEndpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      print("API End-Point: ${ApiUrls.updateProfileEndpoint}");
      print("API End-Point: ${formData.toString()}");
      print("API End-Point: ${response.toString()}");
      return UserModel<Data>.fromJson(
        response.data,
        (dataJson) => Data.fromJson(dataJson),
      );
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<UserModel> deleteAccount() async {
    try {
      final response = await dio.get(ApiUrls.deleteAccountEndPoint);

      print("API End-Point: ${ApiUrls.deleteAccountEndPoint}");
      print("API End-Point: ${response.toString()}");
      return UserModel<Data>.fromJson(
        response.data,
        (dataJson) => Data.fromJson(dataJson),
      );
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<RegisterResponse> resendOTP(String email) async {
    try {
      final response = await dio.post(
        ApiUrls.resendOTPEndpoint,
        data: {'email': email},
      );

      print("API End-Point: ${ApiUrls.resendOTPEndpoint}");
      print("API End-Point: ${email.toString()}");
      print("API End-Point: ${response.toString()}");
      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<RegisterResponse> verifyOTP(String email, String otp) async {
    try {
      final response = await dio.post(
        ApiUrls.verifyOTPEndpoint,
        data: {'email': email, "otp": otp},
      );

      print("API End-Point: ${ApiUrls.verifyOTPEndpoint}");
      print("API End-Point: ${email.toString()}, ${otp.toString()}");
      print("API End-Point: ${response.toString()}");
      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(Constant_fun.extractError(e));
    }
  }

  @override
  Future<dynamic> parseHealthData(Map<String, dynamic> data) async {
    try {
      debugPrint("🧠 Data size: ${utf8.encode(jsonEncode(data)).length} bytes");

      final compressed = gzip.encode(utf8.encode(jsonEncode(data)));
      final response = await dio.post(
        ApiUrls.healthEndpoint,
        data: compressed,
        options: Options(
          headers: {'Content-Encoding': 'gzip'},
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      /*      final response = await dio.post(
        ApiUrls.healthEndpoint,
        data: data,
        options: requestOptions,
      );*/

      debugPrint("API End-Point: ${ApiUrls.healthEndpoint}");
      debugPrint("API End-Point: ${data.toString()}");
      debugPrint("API End-Point: ${response.toString()}");
      return RegisterResponse.fromJson(response.data);
    } catch (e, stackTrace) {
      debugPrint("❌ Dio POST failed with error: $e");
      debugPrint("❌ Stack trace: $stackTrace");

      // Optional: Log DioError details if it's a DioError
      if (e is DioException) {
        debugPrint("🔸 Dio Error Type: ${e.type}");
        debugPrint("🔸 Response: ${e.response}");
        debugPrint("🔸 Message: ${e.message}");
      }

      throw Exception(Constant_fun.extractError(e));
    }
  }
}
