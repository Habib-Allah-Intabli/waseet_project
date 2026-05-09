import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isInitialized = false;

  // Constants for notification channels
  static const String _channelId = 'waseet_notifications';
  static const String _channelName = 'Waseet Notifications';
  static const String _channelDescription = 'Notifications for trip bookings and updates';

  Future<void> initialize() async {
    try {
      // 1. Request permissions
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 2. Initialize local notifications
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint("🔔 Notification clicked: ${details.payload}");
        },
      );

      // 3. Create Android notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 4. Handle foreground FCM messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          showNotification(
            title: notification.title ?? '',
            body: notification.body ?? '',
          );
        }
      });

      _isInitialized = true;
      debugPrint('✅ NotificationService initialized successfully');
    } catch (e) {
      debugPrint('⚠️ NotificationService initialization failed: $e');
    }
  }

  Future<void> showNotification({required String title, required String body}) async {
    if (!_isInitialized) return;
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      // Generate a unique ID to avoid collisions
      final int notificationId = DateTime.now().microsecondsSinceEpoch % 0x7FFFFFFF;

      await _localNotifications.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: platformDetails,
      );
    } catch (e) {
      debugPrint('⚠️ Failed to show notification: $e');
    }
  }

  void startListeningForNotifications(String userId) {
    try {
      _firestore
          .collection('notifications')
          .where('targetUserId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .listen(
        (snapshot) {
          for (var change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data();
              if (data != null) {
                showNotification(
                  title: data['title'] ?? 'تنبيه جديد',
                  body: data['body'] ?? '',
                );
                // Mark as read
                change.doc.reference.update({'isRead': true});
              }
            }
          }
        },
        onError: (error) {
          debugPrint('⚠️ Notification listener error: $error');
        },
      );
    } catch (e) {
      debugPrint('⚠️ Failed to start notification listener: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('⚠️ Failed to get FCM token: $e');
      return null;
    }
  }
}
