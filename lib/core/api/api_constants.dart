import 'dart:developer';

import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';

class ApiConstants {
  static const String baseUrl = 'https://pickup.ryze.website';
  static const String order = '/order';

  static String get token {
    final accessToken = TokenManager().accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return '';
    }
    log('Access token: $accessToken');
    return 'Bearer $accessToken';
  }

  static String getCarLogoUrl(String logoPath) {
    if (logoPath.startsWith('/')) {
      return '$baseUrl/public$logoPath';
    }
    return '$baseUrl/public/$logoPath';
  }
}
