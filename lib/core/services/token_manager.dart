import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _branchIdKey = 'branch_id';
  static const String _deviceTokenKey = 'device_token';
  static final TokenManager _instance = TokenManager._internal();
  late SharedPreferences _prefs;

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save tokens
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? branchId,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _prefs.setString(_refreshTokenKey, refreshToken);
    }
    if (branchId != null) {
      await _prefs.setString(_branchIdKey, branchId);
    }
  }

  // Get access token
  String? get accessToken => _prefs.getString(_accessTokenKey);

  // Get refresh token
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  // Get branch id
  String? get branchId => _prefs.getString(_branchIdKey);

  // Save device token
  Future<void> saveDeviceToken(String deviceToken) async {
    await _prefs.setString(_deviceTokenKey, deviceToken);
  }

  // Get device token
  String? get deviceToken => _prefs.getString(_deviceTokenKey);

  // Clear all tokens (logout)
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_branchIdKey);
    await _prefs.remove(_deviceTokenKey);
  }

  // Check if user is logged in
  bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;
}
