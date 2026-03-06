import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  /// Base URL loaded from .env (used by Dio in injection_container.dart)
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';

  /// Open Trivia Database base URL
  static final triviaBaseUrl = dotenv.env['TRIVIA_API_BASE_URL'] ?? 'https://opentdb.com';
}
