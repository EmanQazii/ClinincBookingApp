import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static List<Map<String, String>> inAppNotifications = [];

  static void addInAppNotification(String title, String body) {
    inAppNotifications.add({'title': title, 'body': body});
  }

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(settings);

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? "",
          body: message.notification!.body ?? "",
        );
      }
    });
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    addInAppNotification(title, body);
    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
