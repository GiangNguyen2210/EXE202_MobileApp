import 'package:flutter/material.dart';
import 'dart:math';
import '../screens/notifications_screen.dart';

// Function to calculate time difference
String _calculateTimeDifference(DateTime receivedAt) {
  final now = DateTime.now();
  final difference = now.difference(receivedAt);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} phút';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} giờ';
  } else {
    return '${difference.inDays} ngày';
  }
}

// Function to generate random color for bell icon
Color _getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final bool isNew;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.isNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isNew ? Colors.grey[200] : Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications,
            color: _getRandomColor(),
            size: 40,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (notification.body.isNotEmpty)
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                Text(
                  _calculateTimeDifference(notification.receivedAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}