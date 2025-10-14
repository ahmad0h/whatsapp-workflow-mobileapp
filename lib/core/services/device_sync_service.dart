// lib/core/services/device_sync_service.dart
import 'dart:developer';
import 'package:whatsapp_workflow_mobileapp/core/services/notification_service.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/device_utils.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/data_source/home_datasource.dart';

class DeviceSyncService {
  final NotificationService _notificationService;
  final TokenManager _tokenManager;
  final HomeDatasource _homeRepo;

  DeviceSyncService({
    required NotificationService notificationService,
    required TokenManager tokenManager,
    required HomeDatasource homeRepo,
  }) : _notificationService = notificationService,
       _tokenManager = tokenManager,
       _homeRepo = homeRepo;

  // lib/core/services/device_sync_service.dart

  Future<void> syncDeviceToken() async {
    try {
      // Always try to sync the device token, regardless of login state
      final deviceId = await DeviceUtils.getDeviceId();
      if (deviceId.isEmpty) {
        log('No device ID available for sync');
        return;
      }

      final currentFcmToken = await _notificationService.getFcmToken();
      if (currentFcmToken == null || currentFcmToken.isEmpty) {
        log('No FCM token available for sync');
        return;
      }

      try {
        // Get the current token, but don't fail if not available
        final token = _tokenManager.accessToken;
        if (token == null || token.isEmpty) {
          log('No access token available, saving token locally only');
          await _tokenManager.saveDeviceToken(currentFcmToken);
          return;
        }

        final deviceInfo = await _homeRepo.getDeviceByDeviceId(deviceId);
        final serverDeviceToken = deviceInfo['deviceToken'] as String?;

        if (serverDeviceToken != currentFcmToken) {
          log('Updating device token on server...');
          await _homeRepo.updateDeviceToken(
            deviceId: deviceId,
            deviceToken: currentFcmToken,
          );
        }
        await _tokenManager.saveDeviceToken(currentFcmToken);
        log('Device token synchronized successfully');
      } catch (e) {
        log('Error during device token sync: $e');
        // Save the token locally even if server update fails
        await _tokenManager.saveDeviceToken(currentFcmToken);
      }
    } catch (e) {
      log('Error in syncDeviceToken: $e');
    }
  }

  Future<String?> getAndSaveCurrentFcmToken() async {
    try {
      final fcmToken = await _notificationService.getFcmToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await _tokenManager.saveDeviceToken(fcmToken);
        return fcmToken;
      }
    } catch (e) {
      log('Error getting and saving FCM token: $e');
    }
    return null;
  }

  Future<bool> isSyncNeeded() async {
    try {
      if (!_tokenManager.isLoggedIn) {
        return false;
      }

      final deviceId = await DeviceUtils.getDeviceId();
      if (deviceId.isEmpty) return false;

      final currentFcmToken = await _notificationService.getFcmToken();
      if (currentFcmToken == null || currentFcmToken.isEmpty) return false;

      final storedDeviceToken = _tokenManager.deviceToken;
      return storedDeviceToken == null ||
          storedDeviceToken.isEmpty ||
          storedDeviceToken != currentFcmToken;
    } catch (e) {
      log('Error checking if sync is needed: $e');
      return false;
    }
  }
}
