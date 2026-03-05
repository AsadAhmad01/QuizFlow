import 'ItemsModel.dart';

class LocationResponse {
  final bool success;
  final String message;
  final List<Location> data;

  LocationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<Location>.from(
                (json['data'] as List).map((x) => Location.fromJson(x)),
              )
              : [],
    );
  }
}
