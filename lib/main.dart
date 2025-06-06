import 'package:exe202_mobile_app/screens/recipe_detail_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/a_bit_about_yours_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/age_picker_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/allergies_selection_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/breakfast_time_selection_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/defines_your_goals.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/dinner_selection_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/gender_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/goal_weight_selection_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/goals_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/health_conditions_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/height_selection_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/login_or_sign_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/lunch_selection_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/weight_selection_screen.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/notifications_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  // Thêm GlobalKey để quản lý Navigator
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initDeepLink();
    }
  }

  Future<void> _initDeepLink() async {
    // Xử lý deep link khi app đang chạy
    _sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null && uri.scheme == 'myapp' && uri.host == 'payment') {
          final orderCode = uri.queryParameters['orderCode'];
          if (orderCode != null) {
            NavigationService.navigateToResultScreen(orderCode);
          }
        }
      },
      onError: (err) {
        print('Lỗi deep link: $err');
      },
    );

    // Xử lý deep link khi app khởi động
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null &&
          initialUri.scheme == 'myapp' &&
          initialUri.host == 'payment') {
        final orderCode = initialUri.queryParameters['orderCode'];
        if (orderCode != null) {
          NavigationService.navigateToResultScreen(orderCode);
        }
      }
    } catch (e) {
      print('Lỗi initial deep link: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginOrSignScreen(),
        '/knowyourgoals': (context) => const DefinesYourGoalsScreen(),
        '/login': (context) => const LoginScreen(),
        'selectgoals': (context) => const GoalsScreen(),
        'abitaboutyour': (context) => const ABitAboutYoursScreen(),
        'genderselection': (context) => const GenderScreen(),
        'ageselection': (context) => const AgePickerScreen(),
        'heightselection': (context) => const HeightSelectionScreen(),
        'weightselection': (context) => const WeightSelectionScreen(),
        'goalweightselection': (context) => const GoalWeightSelectionScreen(),
        'breakfasttimeselection': (context) => const BreakfastTimeScreen(),
        'lunchtimeselection': (context) => const LunchTimeScreen(),
        'dinnertimeselection': (context) => const DinnerTimeScreen(),
        'allergiesselection': (context) => const AllergySelectionScreen(),
        'healthconditionselection': (context) => const HealthConditionScreen(),
        // or define a dynamic one using onGenerateRoute
      },
    );
  }
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
