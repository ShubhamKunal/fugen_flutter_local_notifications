import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinInit = DarwinInitializationSettings();

    final settings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onForegroundTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
    );
  }

  static Future<void> showBasicNotification() async {
    developer.log("Showing notification");

    const androidDetails = AndroidNotificationDetails(
      '1',
      'basic_channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.amber,
      colorized: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Hello',
      'From flutter local notifications',
      notificationDetails,
      payload: 'notification_payload',
    );
  }

  static Future<void> showNotificationWithActions() async {
    developer.log("Showing notification");

    const androidDetails = AndroidNotificationDetails(
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

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Hello',
      'From flutter local notifications',
      notificationDetails,
      payload: 'notification_payload',
    );
  }

  @pragma('vm:entry-point')
  static void _onBackgroundTap(NotificationResponse response) {
    developer.log('Background tap: ${response.payload}');
  }

  static Future<void> _onForegroundTap(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      developer.log('Foreground tap: $payload');
    }
  }
}
