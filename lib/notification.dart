import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "firebase_options.dart";

class FireBaseNotifications{
static FirebaseMessaging messaging =FirebaseMessaging.instance;

Future<void> initializeFireBase() async{
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("Notification received");

  });
}
static Future<String?> getFCMToken() async {
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  final String? fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken;
}
}