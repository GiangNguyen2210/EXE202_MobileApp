class NotificationResponse {
  final List<NotificationItem> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;

  NotificationResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      items: (json['items'] as List)
          .map((item) => NotificationItem.fromJson(item))
          .toList(),
      page: json['page'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      hasNextPage: json['hasNextPage'],
      hasPreviousPage: json['hasPreviousPage'],
    );
  }
}

class NotificationItem {
  final int notificationId;
  final String? title;
  final String? body;
  final String? type;
  final DateTime? createdAt;
  final DateTime? scheduledTime;
  final String? status;

  NotificationItem({
    required this.notificationId,
    this.title,
    this.body,
    this.type,
    this.createdAt,
    this.scheduledTime,
    this.status,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'])
          : null,
      status: json['status'],
    );
  }
}
