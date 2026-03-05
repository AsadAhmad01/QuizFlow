import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ItemsModel.dart';
import '../../data/models/user_model.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }

  static String? getToken() {
    return _prefs?.getString('auth_token');
  }

  static Future<void> removeToken() async {
    await _prefs?.remove('auth_token');
  }

  // Set Email and Password for "Remember Me" functionality
  static Future<void> setCredentials(String email, String password) async {
    await _prefs?.setString('email', email);
    await _prefs?.setString('password', password);
  }

  // Get Email and Password
  static String? getEmail() {
    return _prefs?.getString('email');
  }

  static String? getPassword() {
    return _prefs?.getString('password');
  }

  // Remove Credentials
  static Future<void> removeCredentials() async {
    await _prefs?.remove('email');
    await _prefs?.remove('password');
  }

  // Set Remember Me status
  static Future<void> setRememberMe(bool value) async {
    await _prefs?.setBool('remember_me', value);
  }

  // Get Remember Me status
  static bool getRememberMe() {
    return _prefs?.getBool('remember_me') ?? false;
  }

  // Save User Data object as JSON string
  static Future<void> saveUserData(Data userData) async {
    final String userJson = jsonEncode(userData.toJson());
    await _prefs?.setString('user_data', userJson);
  }

  // Retrieve User Data object from SharedPreferences
  static Data? getUserData() {
    final String? userJson = _prefs?.getString('user_data');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return Data.fromJson(userMap);
    }
    return null; // return null if no data found
  }

  // Remove saved user data (optional, e.g. on logout)
  static Future<void> removeUserData() async {
    removeToken();
    await _prefs?.remove('user_data');
  }

  static Future<void> saveCat_Loc(
    String name,
    List<Category> categories,
  ) async {
    final List<Map<String, dynamic>> categoryList =
        categories.map((e) => e.toJson()).toList();
    final String categoryJson = jsonEncode(categoryList);
    await _prefs?.setString(name, categoryJson);
  }


  static Future<void> updateCat_Loc(String name,
      List<Category> newCategories,) async {
    final String? existingJson = _prefs?.getString(name);
    List<Category> existingCategories = [];

    if (existingJson != null) {
      List<dynamic> decoded = jsonDecode(existingJson);
      existingCategories = decoded.map((e) => Category.fromJson(e)).toList();
    }

    final Map<String, Category> categoryMap = {
      for (var cat in existingCategories) cat.id: cat
    };

    for (var newCat in newCategories) {
      categoryMap[newCat.id] = newCat;
    }

    final updatedList = categoryMap.values.map((e) => e.toJson()).toList();
    final updatedJson = jsonEncode(updatedList);
    await _prefs?.setString(name, updatedJson);
  }


  // Get category list from SharedPreferences
  static List<Category> getCat_Loc(String name) {
    final String? categoryJson = _prefs?.getString(name);
    if (categoryJson != null) {
      final List<dynamic> categoryList = jsonDecode(categoryJson);
      return categoryList.map((item) => Category.fromJson(item)).toList();
    }
    return [];
  }

  // Save current date in 'yyyy-MM-dd' format
  static Future<void> saveCurrentDate() async {
    final String today = DateTime.now().toIso8601String().split('T').first;
    await _prefs?.setString('last_sync_date', today);
  }

// Get saved date
  static String? getSavedDate() {
    return _prefs?.getString('last_sync_date');
  }
}
