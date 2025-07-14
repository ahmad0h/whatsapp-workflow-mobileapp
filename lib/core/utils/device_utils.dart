import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as dev;

class DeviceUtils {
  static const String _deviceIdKey = 'device_id';
  static final Uuid _uuid = const Uuid();

  /// Gets a unique device ID, generating one if it doesn't exist
  static Future<String> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);
      
      // If no device ID exists, generate a new one and save it
      if (deviceId == null) {
        deviceId = _uuid.v4();
        await prefs.setString(_deviceIdKey, deviceId);
        dev.log('Generated new device ID: $deviceId');
      } else {
        dev.log('Using existing device ID: $deviceId');
      }
      
      return deviceId;
    } catch (e) {
      // Fallback to a random UUID if there's an error with SharedPreferences
      final fallbackId = _uuid.v4();
      dev.log('Error getting device ID, using fallback: $fallbackId. Error: $e');
      return fallbackId;
    }
  }
}
