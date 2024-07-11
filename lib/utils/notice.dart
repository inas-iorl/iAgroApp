import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Notify {

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static init() async{
    var not = await Permission.notification;
    await initAndroid();
    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            linux: LinuxInitializationSettings(defaultActionName: 'test')

        )
    );
  }

  static initAndroid() async {
    if (Platform.isAndroid) {
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    }
  }

  static Future sendNotification({required String title, required String body}) async {
    print('sendnotice');
    var androidDetail = AndroidNotificationDetails(
        'btrequest_channel',
        'Requests',
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high
    );
    // print(LinuxFlutterLocalNotificationsPlugin.getCapabilities());
    // final LinuxInitializationSettings linuxDetails =
    // LinuxInitializationSettings(
    //     defaultActionName: 'Open notification');
    LinuxNotificationDetails linuxDetails =
    LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: '0',
          label: 'Action 1',
        ),
      ],
    );
    var notDetail = NotificationDetails(android: androidDetail, linux: linuxDetails);
    // print(title);
    // print(body);
    await flutterLocalNotificationsPlugin.show(0, title, body, notDetail);
  }

  static Future scheduledNotification({
    // required int add_hour,
    // required int minute,
    required String title,
    required String body,
    required int seconds
  }) async {

    var androidDetail = AndroidNotificationDetails(
        'btrequest_channel',
        'Requests',
        importance: Importance.max,
        priority: Priority.high
    );
    LinuxNotificationDetails linuxDetails =
    LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: '0',
          label: 'Action 1',
        ),
      ],
    );
    var notDetail = NotificationDetails(android: androidDetail, linux: linuxDetails);

    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Asia/Almaty'));

    tz.TZDateTime date = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));
    // tz.TZDateTime date = tz.TZDateTime.now(tz.local).add(Duration(minutes: 1));
    body = "$body | $date";
    // print('schedule date $date');
    // print('now date ${tz.TZDateTime.now(tz.local)}');
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      date,
      notDetail,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,//To show notification even when the app is closed
    );
  }

}