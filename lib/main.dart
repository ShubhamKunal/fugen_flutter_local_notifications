import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  developer.log('Background tap: ${notificationResponse.payload}');
}

Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (payload != null) {
    developer.log('Foreground tap: $payload');
  }
}

Future<void> initializeFlutterLocalNotifications() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}


Future<void> displayNotification() async {
  developer.log("Showing notification");

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    '1',
    'basic_channel',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    color: Colors.amber,
    colorized: true

    
  );

  

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Hello',
    'From flutter local notifications',
    notificationDetails,
    payload: 'notification_payload',
    
  );

}

Future<void> displayNotificationWithActions() async {
  developer.log("Showing notification");

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    '1',
    'basic_channel',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    color: Colors.amber,
    colorized: true,
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        '1',
        'Don\'t dismiss',
        showsUserInterface: true,
        cancelNotification: false,
      ),
      AndroidNotificationAction(
        '2',
        'Dismiss',
        showsUserInterface: true,
        cancelNotification: true,
      ),
    ],
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Hello',
    'From flutter local notifications',
    notificationDetails,
    payload: 'notification_payload',
  );
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFlutterLocalNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Flutter Local Notifications'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text("Tap on the button to receive notification"),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
              onPressed: displayNotificationWithActions,
              child: const Text("Show Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
