import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void init() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {}

  static NotificationDetails notificationDetails(
      String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(channelId, channelName,
          importance: Importance.max),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
      linux: const LinuxNotificationDetails(),
    );
  }

  static Future simple(
      {int id = 0,
      required String? title,
      required String? body,
      required String? payLoad,
      String channelId = 'DefaultId',
      channelName = 'Default'}) async {
    return notificationsPlugin.show(
        id, title, body, notificationDetails(channelId, channelName),
        payload: payLoad);
  }

  static Future repeated(
      {int id = 0,
      required String? title,
      required String? body,
      required String? payLoad,
      required RepeatInterval repeatInterval,
      required DateTime scheduledNotificationDateTime,
      String channelId = 'DefaultId',
      channelName = 'Default'}) {
    return notificationsPlugin.periodicallyShow(id, title, body, repeatInterval,
        notificationDetails(channelId, channelName),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payLoad);
  }

  static Future scheduleNotification(
      {int id = 0,
      required String? title,
      required String? body,
      required String? payLoad,
      required DateTime scheduledNotificationDateTime,
      String channelId = 'DefaultId',
      channelName = 'Default'}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        notificationDetails(channelId, channelName),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payLoad);
  }
}
