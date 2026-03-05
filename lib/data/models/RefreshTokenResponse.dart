class RefreshTokenResponse {
  final bool success;
  final String message;
  final String token;

  RefreshTokenResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] == true,
      message: (json['message'] as String?)?.trim().isNotEmpty == true
          ? json['message']
          : 'No message provided',
      token: (json['token'] as String?)?.trim().isNotEmpty == true
          ? json['token']
          : '',
    );
  }
}
