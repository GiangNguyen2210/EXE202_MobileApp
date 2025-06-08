import 'package:exe202_mobile_app/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/home_screen.dart';
import 'screens/subscription_screen.dart';

// import 'screens/meal_planning_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/streak_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/result_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  bool _isNavBarVisible = true;
  late AnimationController _animationController;
  late Animation<Offset> _navBarAnimation;

  // Sample notifications data (replace with real data fetch in production)
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

  // List of screens for navigation
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens list with required arguments
    _screens = [
      HomeScreen(navigatorKey: _navigatorKey), // Index 0
      const SubscriptionScreen(), // Index 1
      NotificationsScreen(notifications: _notifications), // Index 2
      const StreakScreen(), // Index 3 (was Achievement, now Streak)
      ProfileScreen(navigatorKey: _navigatorKey), // Index 4
    ];

    // Initialize animation controller for navbar
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _navBarAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _animationController.reverse();
    print(
      'Animation Controller initialized: ${_animationController.isCompleted}',
    );

    if (!kIsWeb) {
      _initDeepLink();
    }
  }

  Future<void> _initDeepLink() async {
    // Handle deep link when app is running
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

    // Handle deep link when app starts
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

  void _onItemTapped(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
        _isNavBarVisible = true; // Show navbar when switching screens
        _animationController.reverse();
      });
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      print(
        'Scroll Notification - Depth: ${notification.depth}, Delta: ${notification.scrollDelta}, Metrics: ${notification.metrics}',
      );
      final scrollable =
          notification.metrics.maxScrollExtent >
          0; // Check if content is scrollable
      if (notification.scrollDelta! > 0 && _isNavBarVisible && scrollable) {
        print('Hiding navbar');
        setState(() {
          _isNavBarVisible = false;
        });
        _animationController.forward().then((_) {
          print('Animation forward completed');
        });
      } else if (notification.scrollDelta! < 0 &&
          !_isNavBarVisible &&
          scrollable) {
        print('Showing navbar');
        setState(() {
          _isNavBarVisible = true;
        });
        _animationController.reverse().then((_) {
          print('Animation reverse completed');
        });
      }
    }
    return true;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (!_isNavBarVisible) {
              setState(() {
                _isNavBarVisible = true;
              });
              _animationController.reverse().then((_) {
                print('Animation reverse completed on tap');
              });
            }
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: _screens[_currentIndex],
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions),
              label: 'Subscription',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Streak',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          isVisible: _isNavBarVisible,
          animation: _navBarAnimation,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

// AppBottomNavigation widget (unchanged from your provided code)
class AppBottomNavigation extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool isVisible;
  final Animation<Offset>? animation;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const AppBottomNavigation({
    Key? key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.isVisible = true,
    this.animation,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building AppBottomNavigation, isVisible: $isVisible');
    return isVisible
        ? SlideTransition(
            position: animation!,
            child: BottomNavigationBar(
              elevation: 0,
              items: items,
              currentIndex: currentIndex,
              onTap: onTap,
              backgroundColor: backgroundColor ?? Colors.white,
              selectedItemColor: selectedItemColor ?? Colors.orange,
              unselectedItemColor: unselectedItemColor ?? Colors.grey,
            ),
          )
        : const SizedBox.shrink(); // Fully remove the navbar when hidden
  }
}
