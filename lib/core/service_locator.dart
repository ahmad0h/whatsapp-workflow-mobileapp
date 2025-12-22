// lib/core/service_locator.dart
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/device_sync_service.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/notification_service.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/shorebird_update_checker.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/data_source/home_datasource.dart';

final GetIt locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register TokenManager first
  final tokenManager = TokenManager();
  await tokenManager.init();
  locator.registerSingleton<TokenManager>(tokenManager);

  // Register other services
  locator.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );

  try {
    // Initialize notification service
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

  locator.registerLazySingleton<DeviceSyncService>(
    () => DeviceSyncService(
      notificationService: locator<NotificationService>(),
      tokenManager: locator<TokenManager>(),
      homeRepo: locator<HomeDatasource>(),
    ),
  );

  locator.registerLazySingleton<ShorebirdUpdateChecker>(
    () => ShorebirdUpdateChecker(),
  );
}
