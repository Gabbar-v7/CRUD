import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
            linux: initializationSettingsLinux);
    notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print(payload);
    print('object22');
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('notification payload: $payload');
    }
  }

  static NotificationDetails notificationDetails(
      String channelId, String channelName) {
    return NotificationDetails(
        android: AndroidNotificationDetails(channelId, channelName,
            importance: Importance.max),
        iOS: const DarwinNotificationDetails());
  }

  static Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      String channelId = 'DefaultId',
      channelName = 'Default'}) async {
    return notificationsPlugin.show(
        id, title, body, notificationDetails(channelId, channelName));
  }
}
