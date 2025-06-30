import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/notification_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register services as singleton
  locator.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );

  try {
    // Initialize services
    await locator<NotificationService>().initialize();

    // Get and log the FCM token
    final fcmToken = await locator<NotificationService>().getFcmToken();
    if (fcmToken != null) {
      log('FCM Token obtained: $fcmToken');
      // Here you can send the token to your server
    }

    // Set up token refresh handler
    locator<NotificationService>().onTokenRefresh((newToken) {
      log('FCM Token refreshed: $newToken');
      // Here you can send the new token to your server
    });
  } catch (e) {
    log('Error initializing services: $e');
    rethrow;
  }
}
