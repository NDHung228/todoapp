import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationsSettings =
        new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification({
    var id = 0,
    required String title,
    required String body,
    required DateTime scheduledTime,
    var payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',

      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);

    // await fln.show(scheduledTime.second, title, body, not);

    ///////////////////////////////

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "ScheduleNotification001",
      "Notify Me",
      importance: Importance.high,
    );
    tz.initializeTimeZones();
    final now = DateTime.now();
    final scheduledAt = now.add(Duration(seconds: 1));
    final scheduledTZDateTime = tz.TZDateTime.from(scheduledAt, tz.local);

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: null,
      macOS: null,
      linux: null,
    );

    print(
    'demo ' +title
    );

    fln.zonedSchedule(01, title, body, scheduledTZDateTime, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: 'Ths s the data');
  }
}
