import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  Future<String?> requestAndSendFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // ⛔ No need for permission request on Android
    String? token = await messaging.getToken();

    if (token != null) {
      print("FCM Token: $token");
      return token;
    } else {
      print("Failed to get FCM token");
      return null;
    }
  }
}
