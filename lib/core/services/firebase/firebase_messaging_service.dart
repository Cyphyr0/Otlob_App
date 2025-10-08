import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _ordersTopic = 'orders';
  static const String _tawseyaTopic = 'tawseya';

  // Notification channels
  static const String _orderChannelId = 'order_notifications';
  static const String _orderChannelName = 'Order Notifications';
  static const String _orderChannelDescription = 'Notifications for order status updates';

  static const String _tawseyaChannelId = 'tawseya_notifications';
  static const String _tawseyaChannelName = 'Tawseya Notifications';
  static const String _tawseyaChannelDescription = 'Notifications for Tawseya voting reminders';

  static Future<void> initialize() async {
    try {
      // Request permission for notifications
      await _requestNotificationPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Initialize Awesome Notifications
      await _initializeAwesomeNotifications();

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

      // Handle when app is opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen(_firebaseMessagingOpenedAppHandler);

      // Get FCM token for this device
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        // TODO: Send this token to your server to associate with the user
        await _saveFCMToken(token);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_saveFCMToken);

      print('Firebase Messaging initialized successfully');
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
      rethrow;
    }
  }

  static Future<void> _requestNotificationPermission() async {
    if (kIsWeb) {
      // For web, request permission directly
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    } else if (Platform.isIOS) {
      // For iOS, request permission
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }
    // For Android, permissions are handled in AndroidManifest.xml
  }

  static Future<void> _initializeLocalNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap when app is in foreground/background
        _handleNotificationTap(response.payload);
      },
    );
  }

  static Future<void> _initializeAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
      null, // Use default icon
      [
        NotificationChannel(
          channelKey: _orderChannelId,
          channelName: _orderChannelName,
          channelDescription: _orderChannelDescription,
          defaultColor: const Color(0xFFDC2626),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          soundSource: 'resource://raw/notification_sound',
        ),
        NotificationChannel(
          channelKey: _tawseyaChannelId,
          channelName: _tawseyaChannelName,
          channelDescription: _tawseyaChannelDescription,
          defaultColor: const Color(0xFFF59E0B),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          soundSource: 'resource://raw/notification_sound',
        ),
      ],
    );
  }

  // Subscribe to topics
  static Future<void> subscribeToOrderNotifications() async {
    await _firebaseMessaging.subscribeToTopic(_ordersTopic);
    print('Subscribed to order notifications');
  }

  static Future<void> subscribeToTawseyaNotifications() async {
    await _firebaseMessaging.subscribeToTopic(_tawseyaTopic);
    print('Subscribed to Tawseya notifications');
  }

  static Future<void> unsubscribeFromOrderNotifications() async {
    await _firebaseMessaging.unsubscribeFromTopic(_ordersTopic);
    print('Unsubscribed from order notifications');
  }

  static Future<void> unsubscribeFromTawseyaNotifications() async {
    await _firebaseMessaging.unsubscribeFromTopic(_tawseyaTopic);
    print('Unsubscribed from Tawseya notifications');
  }

  // Send local notifications for order updates
  static Future<void> showOrderNotification({
    required String title,
    required String body,
    String? orderId,
    String? imageUrl,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _generateNotificationId(),
        channelKey: _orderChannelId,
        title: title,
        body: body,
        notificationLayout: imageUrl != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        bigPicture: imageUrl,
        payload: {
          'type': 'order',
          'orderId': orderId ?? '',
        },
      ),
    );
  }

  // Send local notifications for Tawseya reminders
  static Future<void> showTawseyaNotification({
    required String title,
    required String body,
    String? votingPeriodId,
    String? imageUrl,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _generateNotificationId(),
        channelKey: _tawseyaChannelId,
        title: title,
        body: body,
        notificationLayout: imageUrl != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        bigPicture: imageUrl,
        payload: {
          'type': 'tawseya',
          'votingPeriodId': votingPeriodId ?? '',
        },
      ),
    );
  }

  // Background message handler
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling background message: ${message.messageId}');

    final notificationData = message.data;
    final notification = message.notification;

    if (notification != null) {
      await _showLocalNotification(
        title: notification.title ?? 'Otlob',
        body: notification.body ?? '',
        payload: jsonEncode(notificationData),
      );
    }
  }

  // Foreground message handler
  static void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    print('Handling foreground message: ${message.messageId}');

    final notificationData = message.data;
    final notification = message.notification;

    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'Otlob',
        body: notification.body ?? '',
        payload: jsonEncode(notificationData),
      );
    }
  }

  // Opened app handler
  static void _firebaseMessagingOpenedAppHandler(RemoteMessage message) {
    print('App opened from notification: ${message.messageId}');
    final notificationData = message.data;

    // Navigate to appropriate screen based on notification type
    _handleNotificationTap(jsonEncode(notificationData));
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'otlob_channel',
      'Otlob Notifications',
      channelDescription: 'Notifications for Otlob app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      _generateNotificationId(),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;

      // TODO: Navigate to appropriate screen based on notification type
      // This will be implemented when we integrate with the navigation system
      print('Notification tapped with data: $data');
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }

  static int _generateNotificationId() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  static Future<void> _saveFCMToken(String token) async {
    // TODO: Save token to Firestore associated with current user
    // This will be implemented when we integrate with auth system
    print('Saving FCM token: $token');
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Open notification settings
  static Future<void> openNotificationSettings() async {
    await AwesomeNotifications().showNotificationConfigPage();
  }
}
