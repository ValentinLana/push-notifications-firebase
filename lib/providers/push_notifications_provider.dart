import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// SHA1: 1D:4F:38:94:62:06:9F:C6:75:A7:73:BD:E4:B0:DA:27:80:B1:9D:F0
// P8 - KeyID: VYZH37GGZ9

// key c0lGwpjZSwep7QcWsW1lV-:APA91bF9BUu2IypYwsTsqo5z4bPx2qSAgVh59wzhBS9Ixr4scBwB7uAZ0RbBqor_siQhSnssBPqmfo_15JgfJHPltm5YW6FEP9Rj-oOQCStwC6F0L0A_IevXhQlKFByy20XBkL-_ebSY

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('onBackground Handler ${message.messageId}');

    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessage Handler ${message.messageId}');

    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp Handler ${message.messageId}');
 
    _messageStream.add('app abierta');
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();

    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notifications
  }

  // Apple / Web
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
