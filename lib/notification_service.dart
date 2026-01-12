import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Notification API wrapper around `flutter_local_notifications`.
class NotificationApi {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Stream of notification payloads when the user taps a notification.
  static final BehaviorSubject<String?> onNotifications =
      BehaviorSubject<String?>();

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
    );
  }

  static Future<void> init({bool initSheduled = false}) async {
    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');

    // flutter_local_notifications v17+: iOS settings are Darwin-based.
    final ios = const DarwinInitializationSettings();

    final settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Only forward the payload; keep behavior consistent with previous code.
        onNotifications.add(response.payload);
      },
    );

    if (initSheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future<void> showNotificaton({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static Future<void> showSheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime sheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(sheduledDate, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
