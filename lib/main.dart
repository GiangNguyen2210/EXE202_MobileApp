import 'package:exe202_mobile_app/screens/recipe_detail_screen.dart';
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
import 'screens/streak_screen.dart'; // Thêm import
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

  // GlobalKey để quản lý Navigator
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
            _navigateToResultScreen(orderCode);
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
          _navigateToResultScreen(orderCode);
        }
      }
    } catch (e) {
      print('Lỗi initial deep link: $e');
    }
  }

  void _navigateToResultScreen(String orderCode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(orderCode: orderCode),
        ),
      );
    });
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
      // navigatorKey: _navigatorKey,
      home: RecipeDetailScreen(), // Pass navigatorKey
      // initialRoute: '/profile',
      // routes: {
      //   '/profile': (context) => HomeScreen(), // Pass navigatorKey
      // },
    );
  }
}