class NotificationResponse {
  final String message;
  final bool success;
  final List<NotificationItem> data;

  NotificationResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List<dynamic>? ?? [];
    List<NotificationItem> notifications =
        list
            .map((i) => NotificationItem.fromJson(i as Map<String, dynamic>))
            .toList();

    return NotificationResponse(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
      data: notifications,
    );
  }
}

class NotificationReadResponse {
  final String message;
  final bool success;
  final NotificationItem data;

  NotificationReadResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory NotificationReadResponse.fromJson(Map<String, dynamic> json) {
    return NotificationReadResponse(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
      data: NotificationItem.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class NotificationItem {
  final String id;
  final String user;
  final String title;
  final String itemId;
  final String message;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
  final int v;

  NotificationItem({
    required this.id,
    required this.user,
    required this.title,
    required this.itemId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'] as String? ?? '',
      user: json['user'] as String? ?? '',
      title: json['title'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      v: json['__v'] as int? ?? 0,
    );
  }
}
