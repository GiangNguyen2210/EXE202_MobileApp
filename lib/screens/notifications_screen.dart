import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/notification_item_widget.dart';

// Notification model to represent data from your database
class NotificationModel {
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.isRead,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Pass the list of notifications from the parent (e.g., fetched from database)
  late final List<NotificationModel> notifications;

  final List<NotificationModel> _notifications = [
    NotificationModel(
      title: 'New Recipe Available',
      body: 'Check out our latest recipe: Spicy Chicken!',
      receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      title: 'Subscription Renewal',
      body: 'Your Basic plan will renew in 3 days.',
      receivedAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      title: 'Update Available',
      body: 'A new app update is ready to download.',
      receivedAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    notifications = _notifications;
  }

  @override
  Widget build(BuildContext context) {
    final newNotifications = notifications.where((n) => !n.isRead).toList();
    final oldNotifications = notifications.where((n) => n.isRead).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'homescreen',
                (route) => false, // Xóa toàn bộ stack, chỉ giữ homescreen
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Text(
                'Notifications',
                style: GoogleFonts.lobster(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onSelected: (String value) {
                if (value == 'mark_all_read') {
                  print('Mark all as read');
                } else if (value == 'delete_all') {
                  print('Delete all notifications');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'mark_all_read',
                  child: Text('Mark as all read'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete_all',
                  child: Text('Delete all notification'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: notifications.length + 2, // +2 for headers
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mới',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else if (index == newNotifications.length + 1) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Trước đó',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              final notificationIndex = index < newNotifications.length + 1
                  ? index - 1
                  : index - 2;
              final notification = index < newNotifications.length + 1
                  ? newNotifications[notificationIndex]
                  : oldNotifications[notificationIndex -
                        newNotifications.length];
              final isNew =
                  !notification.isRead && index <= newNotifications.length;

              return NotificationItem(notification: notification, isNew: isNew);
            }
          },
        ),
      ),
    );
  }
}
