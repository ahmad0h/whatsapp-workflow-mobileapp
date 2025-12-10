import 'dart:developer';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_device_id/persistent_device_id.dart';

class DeviceUtils {
  static const String _deviceIdKey = 'device_id';
  // static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Gets the actual device ID from device hardware and stores it
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    // If no device ID exists, get the actual device ID and store it
    if (deviceId == null) {
      deviceId = await _getPresistantDevieID();
      await prefs.setString(_deviceIdKey, deviceId ?? '');
      log('Generated and stored new device ID: $deviceId');
    } else {
      log('Using existing device ID: $deviceId');
    }

    return deviceId ?? "";
  }

  // /// Gets the actual device ID from device hardware
  // static Future<String> _getActualDeviceId() async {
  //   try {
  //     // For Android
  //     final androidInfo = await _deviceInfoPlugin.androidInfo;
  //     return androidInfo.id; // This returns the Android device ID
  //   } catch (e) {
  //     try {
  //       // Fallback for iOS
  //       final iosInfo = await _deviceInfoPlugin.iosInfo;
  //       return iosInfo.identifierForVendor ?? 'unknown_ios_device';
  //     } catch (e) {
  //       // Ultimate fallback - generate a unique ID based on device info
  //       log('Error getting device ID: $e');
  //       return 'device_${DateTime.now().millisecondsSinceEpoch}';
  //     }
  //   }
  // }

  static Future<String?> _getPresistantDevieID() async {
    final deviceId = await PersistentDeviceId.getDeviceId();
    log("Device ID: $deviceId");
    return deviceId;
  }
}
