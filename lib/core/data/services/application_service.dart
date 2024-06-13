import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/core/data/services/local_notification_service.dart';
import 'package:donation_management/core/data/services/custom_emailjs.dart';

class ApplicationService {
  ApplicationService._();

  /// Singleton to ensure only one class instance is created
  static final ApplicationService _instance = ApplicationService._();
  factory ApplicationService() => _instance;

  /// Initialize mobile services
  static Future<void> initServices() async {
    /// Initialize firebase service
    await FirebaseService.init();

    /// Initialize local notification service
    await LocalNotificationService.initialize();
    // Initialize EmailJS
    CustomEmailJS.init(
      publicKey: 'Im1fVy38_HnYn7wFU',
      privateKey: 'ypWfUCyRmrK_aw__8qNbr',
      host: 'api.emailjs.com',
    );
  }
}
