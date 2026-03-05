class RegisterResponse {
  final bool success;
  final String message;
  final UserData? data;

  RegisterResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UserData {
  final String id;
  final String userName;
  final String email;
  final bool isActive;
  final bool verify;

  UserData({
    required this.id,
    required this.userName,
    required this.email,
    required this.isActive,
    required this.verify,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
      verify: json['verify'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'isActive': isActive,
      'verify': verify,
    };
  }
}
