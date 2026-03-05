import 'dart:io';

import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<dynamic> parseHealthData(Map<String, dynamic> data);
  Future<dynamic> login(Map<String, dynamic> data);
}
