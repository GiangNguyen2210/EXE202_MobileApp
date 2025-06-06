import 'package:flutter/material.dart';
import 'package:exe202_mobile_app/screens/result_screen.dart'; // adjust path

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateToResultScreen(String orderCode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (_) => ResultScreen(orderCode: orderCode)),
      );
    });
  }

  static Future<dynamic> navigateTo(Route route) {
    return navigatorKey.currentState!.push(route);
  }

  static Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
