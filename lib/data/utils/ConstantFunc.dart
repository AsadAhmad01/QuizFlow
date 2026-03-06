import 'package:dio/dio.dart';

class ConstantFunc {
  /// Extracts a human-readable error message from Dio or generic exceptions.
  static String extractError(dynamic e) {
    if (e is DioException) {
      return e.response?.data.toString() ?? e.message ?? 'Unknown error';
    }
    return e.toString();
  }
}
