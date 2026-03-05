import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  /*Base URL for the API*/
  static final baseUrl = dotenv.env['SERVER']!;

  /*Health Data*/
  static const String healthEndpoint = '/health';

  /*Auth Holder*/
  static const String registerEndpoint = '/auth/sign-up';
  static const String loginEndpoint = '/auth/login';
  static const String verifyOTPEndpoint = '/auth/verify-otp';
  static const String resendOTPEndpoint = '/auth/resend-otp';
  static const String forgotPassEndpoint = '/auth/forget-password';
  static const String forgotVerifyOtpEndPoint = '/auth/forgot-verify-otp';
  static const String updatePasswordEndPoint = '/auth/update-password';
  static const String addNewPasswordEndPoint = '/auth/new-password';
  static const String logoutEndPoint = '/auth/logout';
  static const String updateProfileEndpoint = '/auth/update-user-info';
  static const String refreshTokenEndPoint = '/auth/refresh-token';
  static const String deleteAccountEndPoint = '/auth/delete';

  /*Item Holder*/
  static const String homeEndPoint = '/item/get-items-count';
  static const String itemsWithCategoryEndPoint = '/item/group-by-category';
  static const String itemCreateEndPoint = '/item/create';
  static const String itemLentEndPoint = '/item/lent-item';
  static const String itemReceiveEndPoint = '/item/receive-item';
  static const String itemUpdateEndPoint = '/item/update';
  static const String itemDeleteEndPoint = '/item/delete-item';

  /*Category Holder*/
  static const String getCategoryEndPoint = '/category/all';

  /*Location Holder*/
  static const String getLocationEndPoint = '/location/all';
  static const String createLocationEndPoint = '/location/create';
  static const String deleteLocationEndPoint = '/location/delete';

  /*Notification Holder*/
  static const String getNotificationsEndPoint = '/notifications';
  static const String readNotificationEndPoint = '/notifications/mark-read';
}
