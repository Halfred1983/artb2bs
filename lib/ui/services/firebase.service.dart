

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  //
  // await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       channelKey: 'dependo_notification_channel',
  //       title: "Brian is Calling you",
  //       body: "0705458766",
  //       id: 2,
  //       notificationLayout: NotificationLayout.Default,
  //       wakeUpScreen: true,
  //       fullScreenIntent: true,
  //       category: NotificationCategory.Call,
  //       displayOnBackground: true,
  //       displayOnForeground: true,
  //     ),
  //     actionButtons: [
  //       NotificationActionButton(
  //           key: "receive_call",
  //           label: "Receive Call",
  //           actionType: ActionType.Default
  //       ),
  //       NotificationActionButton(
  //           key: "cancel_call",
  //           label: "Cancel Call",
  //           actionType: ActionType.DisabledAction
  //       ),
  //     ]
  // );

  // print("Handling a background message: ${message.messageId}");
// }

class FirebaseService {
  // We use a static function because we won't be able to receive access it in a static method
  // static FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String token = "";


  static Future<FirebaseService> init() async {
    await Firebase.initializeApp(
      // options: FirebaseOptions(
      //     apiKey: "AIzaSyBs4KlKc1pY8VY1dk76-nGYVcEjAPz8DvA",
      //     authDomain: "artb2b-34af2.firebaseapp.com",
      //     projectId: "artb2b-34af2",
      //     storageBucket: "artb2b-34af2.appspot.com",
      //     messagingSenderId: "87564667765",
      //     appId: "1:87564667765:web:a79bb580a3b607b374213c",
      //     measurementId: "G-H38Y4J9G2Y"
      // ),
    );
    // await FirebaseService._messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    // final token = await FirebaseService._messaging.getToken();
    print("token ==> $token");
    FirebaseService.token = token!;

    // FirebaseMessaging.onMessage.listen((message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    return FirebaseService();
  }
}