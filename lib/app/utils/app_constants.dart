import 'package:RoseAI/data/models/signup_resp_model.dart';
import 'package:RoseAI/data/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../data/models/ItemsModel.dart';

class AppConstants {
  static final baseUrl =
      '${dotenv.env['BASE_URL']}'; //* https://api.themoviedb.org/3
  static final apiToken = '${dotenv.env['API_TOKEN']}'; //* your TMDB token
  static final clientID =
      dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static final clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET'] ?? '';
  static final clientID_android =
      dotenv.env['GOOGLE_CLIENT_ID_ANDROID'] ?? '';
  static final clientID_ios =
      dotenv.env['GOOGLE_CLIENT_ID_IOS'] ?? '';

  static bool isHomeCalled = false;
  static bool isItemCalled = true;

  static List<Item> commonItems = [];
  static CategoryData? selectedCategory;
  static List<Category> categories = [];
  static List<CategoryData> categoryData = [];

  static int totalItemCount = 0;
  static int totalItemLentCount = 0;
  static int bottomNavIndex = 0;

  static Data? userModel;
  static RegisterResponse? currentUser;

  static bool isHomeItems = false;
  static bool isSearch = false;
}
