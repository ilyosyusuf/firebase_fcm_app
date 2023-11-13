import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_fcm_app/screens/home_page.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Creating an instance of FirebaseMessaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var token = await FirebaseMessaging.instance.getToken();
  print("Tokenn____________ ${token}");

  // Creating an instance of FlutterLocalNotificationsPluging
  FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

       FirebaseInAppMessaging firebaseInAppMessaging = FirebaseInAppMessaging.instance;
  runApp(MyApp(
    messaging: messaging,
    notifications: notifications,
    inAppMessaging: firebaseInAppMessaging,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseMessaging messaging;
  final FlutterLocalNotificationsPlugin notifications;
  final FirebaseInAppMessaging inAppMessaging;
  const MyApp({required this.messaging, required this.notifications, required this.inAppMessaging});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        messaging: messaging,
        notifications: notifications,
        inAppMessaging: inAppMessaging,
      ),
    );
  }
}
