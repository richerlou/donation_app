import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  /// Singleton to ensure only one class instance is created
  static final LocalNotificationService _instance =
      LocalNotificationService._();
  factory LocalNotificationService() => _instance;

  static final _localNotification = FlutterLocalNotificationsPlugin();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  static const AndroidInitializationSettings _initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  static const InitializationSettings _initializationSettings =
      InitializationSettings(android: _initializationSettingsAndroid);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  static Future<void> initialize() async {
    await _localNotification.initialize(
      _initializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static Future<void> show(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    _localNotification.show(
      notification.hashCode,
      notification!.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
        ),
      ),
    );
  }
}
