class UserModel<T> {
  final bool success;
  final String message;
  final T? data;
  final String? token;

  UserModel({
    required this.success,
    required this.message,
    this.data,
    this.token,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonModel,
  ) {
    return UserModel(
      success: json['success'] == true,
      message:
          (json['message'] as String?)?.trim().isNotEmpty == true
              ? json['message']
              : '',
      data:
          (json['data'] != null && json['data'] is Map<String, dynamic>)
              ? fromJsonModel(json['data'] as Map<String, dynamic>)
              : null,
      token:
          (json['token'] as String?)?.trim().isNotEmpty == true
              ? json['token']
              : '',
    );
  }

  // Convert ApiResponse to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonModel) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonModel(data as T) : null,
      'token': token,
    };
  }
}

class Data {
  final String id;
  final String fullName;
  final String email;
  final String? profileImage;
  final bool isGoogle;
  final bool isApple;
  final bool isAndroid;
  bool isPasswordVerified;
  final String fcmToken;
  final bool isEmailVerified;
  final bool isForgot;
  final String isBlacklisted;

  Data({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
    required this.isGoogle,
    required this.isApple,
    required this.isPasswordVerified,
    required this.isAndroid,
    required this.fcmToken,
    required this.isEmailVerified,
    required this.isForgot,
    required this.isBlacklisted,
  });

  // Convert a JSON object to Data
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profileImage: json['profileImage'],
      isGoogle: json['isGoogle'],
      isApple: json['isApple'],
      isAndroid: json['isAndroid'],
      isPasswordVerified: json['isPasswordVerified'] ?? false,
      fcmToken: json['fcmToken'],
      isEmailVerified: json['isEmailVerified'],
      isForgot: json['isForgot'],
      isBlacklisted: json['isBlacklisted'],
    );
  }

  // Convert Data to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'isGoogle': isGoogle,
      'isApple': isApple,
      'isAndroid': isAndroid,
      'isPasswordVerified': isPasswordVerified,
      'fcmToken': fcmToken,
      'isEmailVerified': isEmailVerified,
      'isForgot': isForgot,
      'isBlacklisted': isBlacklisted,
    };
  }
}
