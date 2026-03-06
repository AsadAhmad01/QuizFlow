import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ─── Auth Token ───────────────────────────────────────────────────────────

  static Future<void> setToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }

  static String? getToken() {
    return _prefs?.getString('auth_token');
  }

  static Future<void> removeToken() async {
    await _prefs?.remove('auth_token');
  }

  // ─── Remember Me Credentials ─────────────────────────────────────────────

  static Future<void> setCredentials(String email, String password) async {
    await _prefs?.setString('email', email);
    await _prefs?.setString('password', password);
  }

  static String? getEmail() => _prefs?.getString('email');

  static String? getPassword() => _prefs?.getString('password');

  static Future<void> removeCredentials() async {
    await _prefs?.remove('email');
    await _prefs?.remove('password');
  }

  static Future<void> setRememberMe(bool value) async {
    await _prefs?.setBool('remember_me', value);
  }

  static bool getRememberMe() {
    return _prefs?.getBool('remember_me') ?? false;
  }

  // ─── User Data ────────────────────────────────────────────────────────────

  static Future<void> saveUserData(Data userData) async {
    final String userJson = jsonEncode(userData.toJson());
    await _prefs?.setString('user_data', userJson);
  }

  static Data? getUserData() {
    final String? userJson = _prefs?.getString('user_data');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return Data.fromJson(userMap);
    }
    return null;
  }

  static Future<void> removeUserData() async {
    await removeToken();
    await _prefs?.remove('user_data');
  }

  // ─── Sync Date ────────────────────────────────────────────────────────────

  static Future<void> saveCurrentDate() async {
    final String today = DateTime.now().toIso8601String().split('T').first;
    await _prefs?.setString('last_sync_date', today);
  }

  static String? getSavedDate() {
    return _prefs?.getString('last_sync_date');
  }
}
