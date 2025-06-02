import 'package:exe202_mobile_app/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/home_screen.dart';
import 'screens/notifications_screen.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
     const MaterialApp(debugShowCheckedModeBanner: false, home: ProfileScreen()),
  );
}



// Test Noti Screen using this
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // Sample notifications list
//   final List<NotificationModel> notifications = [
//     NotificationModel(
//       title: "Nguyệt Trường Lộc đã nhắn",
//       body: "đen bụi ở mặt bình luận Việt Nam Th...",
//       receivedAt: DateTime.now().subtract(Duration(minutes: 19)),
//       isRead: true,
//     ),
//     NotificationModel(
//       title: "POKEMON VN CLUB: ## [GIVEAWAY] QUỐC TẾ THIẾU N...",
//       body: "",
//       receivedAt: DateTime.now().subtract(Duration(hours: 3)),
//       isRead: false,
//     ),
//     NotificationModel(
//       title: "Nguyện Quỳnh Anh đã nhắn đen bạn",
//       body: "bán vài nhân trong POKÉMON ở VN...",
//       receivedAt: DateTime.now().subtract(Duration(hours: 3)),
//       isRead: false,
//     ),
//     NotificationModel(
//       title: "PokéCorner đã nhắn đen bạn ở một bình luận...",
//       body: "Mua Bán, Trao Đổi Hội Đam Mê...",
//       receivedAt: DateTime.now().subtract(Duration(hours: 21)),
//       isRead: true,
//     ),
//     NotificationModel(
//       title: "Sadness Ezreal đã phát trực tiếp: \"Lắm tì lúc b...",
//       body: "",
//       receivedAt: DateTime.now().subtract(Duration(hours: 22)),
//       isRead: true,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: NotificationsScreen(notifications: notifications),
//     );
//   }
// }