import 'dart:io';
import 'package:exe202_mobile_app/screens/home_screen.dart';
import 'package:exe202_mobile_app/screens/notifications_screen.dart';
import 'package:exe202_mobile_app/screens/profile_screen.dart';
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
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/notification_acceptance_screen.dart';
import 'package:exe202_mobile_app/screens/sign_up_screens_flow/weight_selection_screen.dart';
import 'package:exe202_mobile_app/screens/streak_screen.dart';
import 'package:exe202_mobile_app/screens/subscription_screen.dart';
import 'package:exe202_mobile_app/screens/suggestion_screen.dart'; // Thêm import
import 'package:exe202_mobile_app/service/local_notification_service.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:exe202_mobile_app/widgets/app_bottom_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/login_screen.dart';
import 'screens/result_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');

  HttpOverrides.global = MyHttpOverrides();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📥 Foreground FCM: ${message.notification?.title}');
    LocalNotificationService.showNotification(message);
  });

  runApp(MyApp(initialRoute: token != null ? 'homescreen' : '/'));
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.reverse();

    LocalNotificationService.initialize();

    if (!kIsWeb) {
      _initDeepLink();
    }
  }

  Future<void> _initDeepLink() async {
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
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: widget.initialRoute,
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
        'homescreen': (context) =>
        const MyBottomNavigator(currentIndex: 0, child: HomeScreen()),
        'subscreen': (context) => const MyBottomNavigator(
          currentIndex: 1,
          child: SubscriptionScreen(),
        ),
        'notiscreen': (context) => const MyBottomNavigator(
          currentIndex: 2,
          child: NotificationsScreen(),
        ),
        'streakscreen': (context) =>
        const MyBottomNavigator(currentIndex: 3, child: StreakScreen()),
        'profilescreen': (context) =>
        const MyBottomNavigator(currentIndex: 4, child: ProfileScreen()),
        'suggestionscreen': (context) => // Thêm route mới
        MyBottomNavigator(currentIndex: 5, child: SuggestionScreen()),
        'notiacceptance': (context) => const NotificationAcceptanceScreen(),
      },
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
    );
  }
}