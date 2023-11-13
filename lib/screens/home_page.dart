import 'dart:convert';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final FirebaseMessaging messaging;
  final FlutterLocalNotificationsPlugin notifications;
  final FirebaseInAppMessaging inAppMessaging;
  const HomePage(
      {Key? key,
      required this.messaging,
      required this.notifications,
      required this.inAppMessaging})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Request permission to receive notifications on iOS
    widget.messaging.requestPermission(alert: true, badge: true, sound: true);

    // Configure FirebaseMessaging to handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Initialize FlutterLocalNotificationsPlugin
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitializationSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);
    widget.notifications.initialize(initializationSettings);
  }

  void _showNotification(RemoteMessage message) async {
    var androidDetails = AndroidNotificationDetails('channelId', 'channelName',
        priority: Priority.high, importance: Importance.high);

    var iOSDetails = IOSNotificationDetails();
    var platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await widget.notifications.show(0, message.notification!.title,
        message.notification!.body, platformDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase FCM App"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await sendFCMMessage(
                    "frHlVPXESyqiFxTR7pShHH:APA91bENBtlpYiE3eszWP4PxpKKhGnOjGsH-iefZtcSzSIrffy5yI4UgQlhzgXw84berqqxB8sta5wQJYbdUv7Y3E1PzhfTVpwv4wd-OFMd6g8LYAGh3gYyTzN2-JISuMVDw9RBX5LAy",
                    "Salom");
              },
              child: Text("Send Notification"),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
              await widget.inAppMessaging.triggerEvent('in_app_purchase');
              },
              child: Text("Send InApp"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendFCMMessage(String fcmToken, String message) async {
    final postUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAOyxLTnE:APA91bGbHqN39dfkl-NhAES4vNY1-1Wq6gsQgULVDiTeb2iI1SSpkXrb59bVQ-DP1DXzbyThUIb9O9ZOuTwCjlh26ihONV-iYYZjfzgEsyo6tI3lCRtHD9FzeDLlgfwLjV6UymL7bCwi',
    };

    final body = <String, dynamic>{
      'to': fcmToken,
      'notification': {'title': 'My App', 'body': message},
    };

    final response = await http.post(
      postUrl,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully!');
    } else {
      print(
          'FCM message failed to send with status code: ${response.statusCode}');
    }
  }
}
