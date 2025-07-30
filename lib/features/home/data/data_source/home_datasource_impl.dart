import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/api_constants.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/dio_helper.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/data_source/home_datasource.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/device_init_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/get_branch_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/is_linked_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_stats_response_mode.dart';

@Injectable(as: HomeDatasource)
class HomeDatasourceImpl implements HomeDatasource {
  @override
  Future<List<OrderModel>> getOrdersData() async {
    var response = await DioHelper.getData(
      url:
          '${ApiConstants.baseUrl}${ApiConstants.order}/${TokenManager().branchId}',
      headers: {'Authorization': ApiConstants.token},
    );

    try {
      if (response.data is String) {
        final decoded = jsonDecode(response.data);
        if (decoded is List) {
          return decoded
              .map<OrderModel>((item) => OrderModel.fromJson(item))
              .toList();
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('Status') && !decoded['Status']) {
            throw Exception(decoded['Message'] ?? 'Request failed');
          }

          return [OrderModel.fromJson(decoded)];
        }
      } else if (response.data is List) {
        return (response.data as List)
            .map<OrderModel>((item) => OrderModel.fromJson(item))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('Status') && !response.data['Status']) {
          throw Exception(response.data['Message'] ?? 'Request failed');
        }

        return [OrderModel.fromJson(response.data)];
      }

      throw Exception('Unexpected response format');
    } catch (e) {
      throw Exception('Failed to process response: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await DioHelper.postData(
        url: '${ApiConstants.baseUrl}${ApiConstants.order}/$orderId/status',
        data: {'status': status},
        headers: {'Authorization': ApiConstants.token},
      );

      if (response.data is Map && response.data['message'] != null) {
        log('Status updated successfully: ${response.data['message']}');
        return;
      }

      throw Exception('Unexpected response format: ${response.data}');
    } catch (e) {
      log('Error updating order status: $e');
      rethrow;
    }
  }

  @override
  Future<void> rejectOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: '${ApiConstants.baseUrl}${ApiConstants.order}/$orderId/reject',
        data: {'notes': reason},
        headers: {'Authorization': ApiConstants.token},
      );

      // Check if response contains the updated order with rejected status
      if (response.data is Map) {
        final data = response.data as Map<String, dynamic>;

        // If response has a message field, use it
        if (data['message'] != null) {
          log('Order rejected successfully: ${data['message']}');
          return;
        }

        // If response contains order data with rejected status, consider it successful
        if (data['status'] == 'rejected' || data['id'] != null) {
          log('Order rejected successfully - status updated to rejected');
          return;
        }
      }

      throw Exception('Unexpected response format: ${response.data}');
    } catch (e) {
      log('Error rejecting order: $e');
      rethrow;
    }
  }

  @override
  Future<OrderStatsReponseModel> getOrderStats() async {
    try {
      final response = await DioHelper.getData(
        url: '${ApiConstants.baseUrl}${ApiConstants.order}/stats',
        headers: {'Authorization': ApiConstants.token},
        query: {'branchId': TokenManager().branchId},
      );

      try {
        if (response.data is Map) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(
            response.data,
          );
          // log('Response data: $data');
          final stats = OrderStatsReponseModel.fromJson(data);

          return stats;
        } else {
          log('Response is not a Map, throwing format error');
          throw Exception('Response is not a Map');
        }
      } catch (e, stackTrace) {
        log('Error processing order stats: $e\n$stackTrace');
        rethrow;
      }
    } catch (e) {
      log('Error getting order stats: $e');
      rethrow;
    }
  }

  @override
  Future<DeviceInitReponseModel> initDevice({
    required String deviceId,
    String? deviceToken,
  }) async {
    try {
      final data = {'deviceId': deviceId};
      if (deviceToken != null) {
        data['deviceToken'] = deviceToken;
      }

      final response = await DioHelper.postData(
        url: '${ApiConstants.baseUrl}/devices/init',
        data: data,
      );
      log('Init device response: ${response.data}');
      return DeviceInitReponseModel.fromJson(response.data);
    } catch (e) {
      log('Error initializing device: $e');
      rethrow;
    }
  }

  @override
  Future<IsLinkedReponseModel> isLinked({required String deviceId}) async {
    try {
      final response = await DioHelper.getData(
        url: '${ApiConstants.baseUrl}/devices/status/$deviceId',
      );

      // If status is 404, device is not linked
      if (response.statusCode == 404) {
        log('Device not found (404), treating as not linked');
        return _createUnlinkedResponse();
      }

      // If we got a successful response, save tokens and return the linked status
      if (response.statusCode == 200) {
        final tokenManager = TokenManager();
        tokenManager.saveTokens(
          accessToken: response.data['accessToken'] as String? ?? '',
          refreshToken: response.data['refreshToken'] as String? ?? '',
          branchId: response.data['branchId'] as String? ?? '',
        );
        log('Device status response: ${response.data}');
        return IsLinkedReponseModel.fromJson(response.data);
      }

      // For any other status code, log and return unlinked
      log('Unexpected status code: ${response.statusCode}');
      return _createUnlinkedResponse();
    } on DioException catch (e) {
      // Handle Dio-specific errors (including 404s)
      if (e.response?.statusCode == 404) {
        log('Device not found (404) - DioException');
      } else {
        log('Dio error checking device status: ${e.message}');
      }
      return _createUnlinkedResponse();
    } catch (e) {
      log('Unexpected error checking device status: $e');
      return _createUnlinkedResponse();
    }
  }

  IsLinkedReponseModel _createUnlinkedResponse() {
    return IsLinkedReponseModel(
      status: 'UNLINKED',
      branchId: '',
      accessToken: '',
      refreshToken: '',
    );
  }

  @override
  Future<List<OrderModel>> getOrdersDataByBranchIdAndDate({
    required String date,
  }) async {
    final response = await DioHelper.getData(
      url:
          '${ApiConstants.baseUrl}${ApiConstants.order}/branch/${TokenManager().branchId}',
      headers: {'Authorization': ApiConstants.token},
      query: {'date': date},
    );

    log('Orders data response: ${response.data}');

    try {
      if (response.data is String) {
        final decoded = jsonDecode(response.data);
        if (decoded is List) {
          return decoded
              .map<OrderModel>((item) => OrderModel.fromJson(item))
              .toList();
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('Status') && !decoded['Status']) {
            throw Exception(decoded['Message'] ?? 'Request failed');
          }

          return [OrderModel.fromJson(decoded)];
        }
      } else if (response.data is List) {
        return (response.data as List)
            .map<OrderModel>((item) => OrderModel.fromJson(item))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('Status') && !response.data['Status']) {
          throw Exception(response.data['Message'] ?? 'Request failed');
        }

        return [OrderModel.fromJson(response.data)];
      }

      throw Exception('Unexpected response format');
    } catch (e) {
      throw Exception('Failed to process response: $e');
    }
  }

  @override
  Future<GetBranchResponseModel> getBranchesData() async {
    try {
      final response = await DioHelper.getData(
        url: '${ApiConstants.baseUrl}/branch/${TokenManager().branchId}',
        headers: {'Authorization': ApiConstants.token},
      );
      log('Branch data response: ${response.data}');
      return GetBranchResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to process response: $e');
    }
  }
}
