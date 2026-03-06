import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central repository for all API base URLs and endpoint paths.
class AppEndpoints {
  // ─── Base URLs (loaded from .env) ─────────────────────────────────────────

  /// Backend API base URL  — e.g. https://api.example.com
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// Open Trivia Database base URL — https://opentdb.com
  static String get triviaBaseUrl =>
      dotenv.env['TRIVIA_API_BASE_URL'] ?? 'https://opentdb.com';

  // ─── Auth Endpoints ───────────────────────────────────────────────────────

  /// POST /auth/login  — email + password login
  static const String login = '/auth/login';

  /// POST /auth/sign-up  — new user registration
  static const String register = '/auth/sign-up';

  /// POST /auth/verify-otp  — verify email OTP
  static const String verifyOtp = '/auth/verify-otp';

  /// POST /auth/resend-otp  — resend email OTP
  static const String resendOtp = '/auth/resend-otp';

  /// POST /auth/forget-password  — request password reset
  static const String forgotPassword = '/auth/forget-password';

  /// POST /auth/forgot-verify-otp  — verify forgot-password OTP
  static const String forgotVerifyOtp = '/auth/forgot-verify-otp';

  /// POST /auth/new-password  — set new password after OTP verify
  static const String newPassword = '/auth/new-password';

  /// POST /auth/update-password  — change password while logged in
  static const String updatePassword = '/auth/update-password';

  /// GET  /auth/logout  — invalidate server session
  static const String logout = '/auth/logout';

  /// POST /auth/update-user-info  — update profile (name / avatar)
  static const String updateProfile = '/auth/update-user-info';

  /// GET  /auth/refresh-token  — refresh JWT
  static const String refreshToken = '/auth/refresh-token';

  /// GET  /auth/delete  — permanently delete account
  static const String deleteAccount = '/auth/delete';

  // ─── Open Trivia DB Endpoints ─────────────────────────────────────────────

  /// GET /api.php?amount=&category=&type=  — fetch trivia questions
  static const String triviaQuestions = '/api.php';
}
