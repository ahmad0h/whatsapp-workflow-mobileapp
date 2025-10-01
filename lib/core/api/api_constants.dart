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
    // If the path already contains the full base URL, return it as-is
    if (logoPath.startsWith(baseUrl)) {
      return logoPath;
    }
    // If the path starts with /public/, prepend the base URL
    if (logoPath.startsWith('/public/')) {
      return '$baseUrl$logoPath';
    }
    // If the path starts with /, prepend base URL + /public
    if (logoPath.startsWith('/')) {
      return '$baseUrl/public$logoPath';
    }
    // Otherwise, prepend base URL + /public/
    return '$baseUrl/public/$logoPath';
  }
}
