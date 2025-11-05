import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notification services
  Future<void> initialize() async {
    await _requestNotificationPermission();
    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();

    // Listen for messages when app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? message.data['title'] ?? '';
      final body = message.notification?.body ?? message.data['body'] ?? '';

      if (title.contains('Device Unlinked') ||
          body.contains('device has been successfully unlinked')) {
        _handleDeviceUnlinked();
      }
    });
  }

  // Request notification permission
  Future<bool> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // On iOS, we need to request notification permissions through Firebase
      final NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: false,
          );
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return false;
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              'default',
              actions: <DarwinNotificationAction>[],
            ),
          ],
        );

    // Handle notification taps in the onDidReceiveNotificationResponse callback
    // when setting up the FlutterLocalNotificationsPlugin

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap
        debugPrint('Notification tapped: ${details.payload}');
      },
    );
  }

  // Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Get the token for this device
    String? token = await _firebaseMessaging.getToken();
    // log('FCM Token: $token');
    if (token != null) {
      // log('FCM Token: $token');
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification}',
        );
        _showLocalNotification(message);
      }
    });

    // Handle when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message clicked when app is in background!');
      _handleNotificationTap(message);
    });

    // Handle when the app is terminated
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'default_channel',
          'Default Channel',
          channelDescription: 'Default notification channel',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          playSound: false, // Disable sound for Android
          sound: null, // Explicitly set sound to null
        );

    final DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentSound: false, // Disable sound for iOS
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    // Handle navigation based on the message data
    debugPrint('Notification tapped with data: ${message.data}');

    // Check for Device Unlinked notification
    final title = message.notification?.title ?? message.data['title'] ?? '';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    if (title.contains('Device Unlinked') ||
        body.contains('device has been successfully unlinked')) {
      _handleDeviceUnlinked();
    }
  }

  // Handle device unlinked notification
  void _handleDeviceUnlinked() async {
    debugPrint('Handling device unlinked notification');
    // Get the TokenManager instance
    final tokenManager = TokenManager();
    await tokenManager.clearTokens();

    // Navigate to auth screen using navigatorKey
    if (navigatorKey.currentState?.mounted ?? false) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        GoRouterConfig.authView,
        (route) => false, // Remove all previous routes
      );
    }
  }

  // Add a GlobalKey for navigation
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  // Show a local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'local_channel',
          'Local Notifications',
          channelDescription: 'Channel for local notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          playSound: false, // Disable sound for Android
          sound: null, // Explicitly set sound to null
        );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentSound: false, // Disable sound for iOS
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: payload?.toString(),
    );
  }

  // Get the current FCM token
  Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Handle token refresh
  void onTokenRefresh(Function(String) onTokenRefreshCallback) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      onTokenRefreshCallback(newToken);
    });
  }
}
