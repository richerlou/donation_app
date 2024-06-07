import 'package:donation_management/core/data/services/http_service.dart';
import 'package:donation_management/core/data/services/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();

  /// Singleton to ensure only one class instance is created
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._();
  factory FirebaseMessagingService() => _instance;

  static final FirebaseMessaging _fcmInstance = FirebaseMessaging.instance;

  static const String _sendFCMUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String _fcmAuthKey =
      'AAAA30_Hnqs:APA91bEYaeDWv5G4Zm9Eodb13D2CkOGnciwwZ4OjFiiH2nxjfPZVgQizT_OkVIEzZPSLfEVMd5GcXGyOfB-gidGFE3M3WUYCoi7pz9i2R-rVuDKlRlEle5q_kbxGHehc1UFFTugGWesi';

  /// Get FCM token
  Future<String?> getFCMToken() => _fcmInstance.getToken();

  /// Request FCM permission
  static Future<NotificationSettings> requestPermission() async {
    return await _fcmInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static void onForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      LocalNotificationService.show(event);
    });
  }

  /// Handles process when notification receives and tapped from background
  static void onBackgroundHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // TODO: Background
    });
  }

  // Send push notification via REST
  static Future<void> sendPushMessage(Object data) async {
    await HttpService.postRequest(
      url: _sendFCMUrl,
      headers: {
        'Authorization': 'key=$_fcmAuthKey',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );
  }
}
