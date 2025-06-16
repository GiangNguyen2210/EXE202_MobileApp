import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/streak_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/suggestion_screen.dart'; // Thêm import

class MyBottomNavigator extends StatefulWidget {
  final int currentIndex;
  final Widget child;

  const MyBottomNavigator({
    Key? key,
    required this.currentIndex,
    required this.child,
  }) : super(key: key);

  @override
  State<MyBottomNavigator> createState() => _MyBottomNavigatorState();
}

class _MyBottomNavigatorState extends State<MyBottomNavigator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _navBarAnimation;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(), // Index 0
      const SubscriptionScreen(), // Index 1
      const NotificationsScreen(), // Index 2
      const StreakScreen(), // Index 3
      const ProfileScreen(), // Index 4
      SuggestionScreen(), // Index 5 (Mới)
    ];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _navBarAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (index != widget.currentIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => _screens[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppBottomNavigation(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Noti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Streak',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Suggestions'), // Mới
        ],
        currentIndex: widget.currentIndex,
        onTap: _onTap,
        isVisible: true,
        animation: _navBarAnimation,
      ),
    );
  }
}

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
        : const SizedBox.shrink();
  }
}