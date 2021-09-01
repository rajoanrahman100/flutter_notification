import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationAPI {
  //Declare the notification plugin first

  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static initTzTime() {
    tz.initializeTimeZones();
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notifications.show(id, title, body, await notificationDetails(),
        payload: payload);
  }

  static Future showScheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleTime}) async {
    return notifications.zonedSchedule(id, title, body,
        tz.TZDateTime.from(scheduleTime, tz.local), await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future showScheduleDailyNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleTime}) async {
    return notifications.zonedSchedule(id, title, body,
        scheduleDaily(Time(8)), await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,matchDateTimeComponents: DateTimeComponents.time);
  }


  static tz.TZDateTime scheduleDaily(Time time){
    final now=tz.TZDateTime.now(tz.local);
    final scheduleDate=tz.TZDateTime(tz.local,now.year,now.month,now.day,time.hour,time.minute,time.second);
    
    return scheduleDate.isBefore(now)?scheduleDate.add(Duration(days: 1)):scheduleDate;
  }



  static Future notificationDetails() async {

    final bigPicturePath=await Utils.downloadFile("https://images.unsplash.com/photo-1569173112611-52a7cd38bea9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80","bigImage");
    final largeIconPath=await Utils.downloadFile("https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=104&q=80","bigIcon");

    final styleInformation=BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
        largeIcon:FilePathAndroidBitmap(largeIconPath)
    );

    return NotificationDetails(
        android: AndroidNotificationDetails(
            "channel id", "channel name", "channel description",
            importance: Importance.max,styleInformation: styleInformation),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool initSchedule = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final setting = InitializationSettings(android: android, iOS: ios);

    //When app is closed
    final details=await notifications.getNotificationAppLaunchDetails();

    if(details!=null && details.didNotificationLaunchApp){
      onNotification.add(details.payload);
    }

    await notifications.initialize(setting,
        onSelectNotification: (payload) async {
      onNotification.add(payload);
    });
    if(initSchedule){
      tz.initializeTimeZones();
      final localtime=await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localtime));
    }
  }
}


class Utils{
  static Future<String> downloadFile(String url, String fileName)async{
    final directory=await getApplicationDocumentsDirectory();
    final filePath='${directory.path}/$fileName';
    final response=await http.get(Uri.parse(url));
    final file=File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
