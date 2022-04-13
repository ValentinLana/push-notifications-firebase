import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notifications/pages.dart/mensaje_page.dart';

import 'pages.dart/home_page.dart';
import 'providers/push_notifications_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    PushNotificationService.messaging
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        final snackBar = SnackBar(content: Text(message.data['product']));
        messengerKey.currentState?.showSnackBar(snackBar);
        navigatorKey.currentState
            ?.pushNamed('message', arguments: message.data['product']);
      }
    });

    //context
    PushNotificationService.messagesStream.listen((message) {
      navigatorKey.currentState?.pushNamed('message', arguments: message);
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey, // Navegar
      scaffoldMessengerKey: messengerKey, // Snacks
      routes: {
        'home': (_) => HomePage(),
        'message': (_) => MensajePage(),
      },
    );
  }
}
