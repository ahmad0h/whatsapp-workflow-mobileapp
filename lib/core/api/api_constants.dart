import 'dart:developer';

import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';

class ApiConstants {
  static const String baseUrl = 'https://38d043b839f4.ngrok-free.app';
  static const String order = '/order';

  static String get token {
    final accessToken = TokenManager().accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return '';
    }
    log('Access token: $accessToken');
    return 'Bearer $accessToken';
  }
}
