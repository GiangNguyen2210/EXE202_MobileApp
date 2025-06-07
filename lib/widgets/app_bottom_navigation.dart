import 'package:flutter/material.dart';

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
    Widget navBar = BottomNavigationBar(
      elevation: 0,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor ?? Colors.white,
      selectedItemColor: selectedItemColor ?? Colors.orange,
      unselectedItemColor: unselectedItemColor ?? Colors.grey,
    );

    if (animation != null && isVisible != null) {
      return SlideTransition(
        position: animation!,
        child: isVisible ? navBar : null,
      );
    }

    return navBar;
  }
}

