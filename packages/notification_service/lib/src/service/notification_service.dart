import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart' hide Notification;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../models/models.dart';

/// {@template notification_repository}
/// A repository for the Notifications domain baked with [FirebaseMessaging].
/// {@endtemplate}
class NotificationService {
  /// {@macro notification_repository}
  NotificationService({
    String? vapidKey,
    FirebaseMessaging? firebaseMessaging,
    String? userId,
    firestore.FirebaseFirestore? database,
    Stream<RemoteMessage>? onNotificationOpened,
    Stream<RemoteMessage>? onForegroundNotification,
  })  : _vapidKey = vapidKey,
        _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _firestore = database,
        _onForegroundNotification =
            onForegroundNotification ?? FirebaseMessaging.onMessage,
        _onNotificationOpenedController = BehaviorSubject<Notification>() {
    _initialize(onNotificationOpened ?? FirebaseMessaging.onMessageOpenedApp);
  }

  final String? _vapidKey;
  final FirebaseMessaging _firebaseMessaging;
  final Stream<RemoteMessage> _onForegroundNotification;
  final BehaviorSubject<Notification> _onNotificationOpenedController;
  final firestore.FirebaseFirestore? _firestore;


  Future<void> _initialize(Stream<RemoteMessage> onNotificationOpened) async {
    final response = await _firebaseMessaging.requestPermission();
    final status = response.authorizationStatus;
    if (status == AuthorizationStatus.authorized) {
      final message = await _firebaseMessaging.getInitialMessage();
      // final token = await _firebaseMessaging.getToken(vapidKey: _vapidKey);
      // if(_userId != null && _userId!.isNotEmpty) await _sendTokenToServer(token!);
      if (message != null) {
        _onMessageOpened(message);
      }
      onNotificationOpened.listen(_onMessageOpened);
    }
  }

  Future<void> sendTokenToServer(String userId) async {
    // If you're running your own server, call API to send token and today's date for the user
    final token = await _firebaseMessaging.getToken(vapidKey: _vapidKey);

    // Example shown below with Firestore
    // Add token and timestamp to Firestore for this user
    var tokenMap = {
      'token': token,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Get user ID from Firebase Auth or your own server
    return _firestore!.collection("fcmTokens").doc(userId)
        .set(tokenMap);
  }

  void _onMessageOpened(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _onNotificationOpenedController.sink.add(
        Notification(
            title: notification.title ?? '',
            body: notification.body ?? '',
            screen: message.data['screen'] ?? ''
        ),
      );
    }
  }

  /// Returns a [Stream] that emits when a user presses a [Notification]
  /// message displayed via FCM.
  ///
  /// If your app is opened via a notification whilst the app is terminated,
  /// see [FirebaseMessaging.getInitialMessage].
  Stream<Notification> get onNotificationOpened {
    return _onNotificationOpenedController.stream;
  }

  /// Returns a [Stream] that emits when an incoming [Notification] is
  /// received whilst the Flutter instance is in the foreground.
  Stream<Notification> get onForegroundNotification {
    return _onForegroundNotification.mapNotNull((message) {
      final notification = message.notification;
      if (notification == null) {
        return null;
      }
      return Notification(
          title: notification.title ?? '',
          body: notification.body ?? '',
          screen: message.data['screen'] ?? ''
      );
    });
  }

  /// Subscribe to topic in background.
  Future<void> subscribeToTopic(Topic topic) async {
    await _firebaseMessaging.subscribeToTopic(topic.name);
  }

  /// Unsubscribe from topic in background.
  Future<void> unsubscribeFromTopic(Topic topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic.name);
  }
}