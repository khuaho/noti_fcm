import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

late NotificationSettings settings;

class FirebaseConfig {
  static Future<void> setupFlutterNotifications() async {
    try {
      settings = await requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.onBackgroundMessage(
          FirebaseConfig.firebaseMessagingBackgroundHandler,
        );
      }
    } catch (exception, stackTrace) {
      print('loi: $stackTrace');
      // await Sentry.captureException(
      //   exception,
      //   stackTrace: stackTrace,
      // );
    }
  }

  static Future<NotificationSettings> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    return settings;
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage,
  ) async {
    await Firebase.initializeApp();
  }

  static Future<String?> getFirebaseMessagingToken() async {
    String? token = await FirebaseMessaging.instance.getToken(
      vapidKey: '',
    );

    return token;
  }
}
