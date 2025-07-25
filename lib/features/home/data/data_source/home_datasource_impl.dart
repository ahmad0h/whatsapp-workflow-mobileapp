import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/api_constants.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/dio_helper.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/data_source/home_datasource.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';

@Injectable(as: HomeDatasource)
class HomeDatasourceImpl implements HomeDatasource {
  @override
  Future<List<OrderModel>> getOrdersData() async {
    var response = await DioHelper.getData(
      url: '${ApiConstants.baseUrl}${ApiConstants.order}',
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c3JfMTIzNDU2Nzg5MCIsImVtYWlsIjoib3duZXJAZXhhbXBsZS5jb20iLCJyb2xlIjoiYnVzaW5lc3Nfb3duZXIiLCJpYXQiOjE3NTI0Nzk4NTksImV4cCI6MTc1MjU2NjI1OX0.LArx4C7AhN6VFONYFahqjmk4_SJw6SjTsddah6sRt7A',
      },
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
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c3JfMTIzNDU2Nzg5MCIsImVtYWlsIjoib3duZXJAZXhhbXBsZS5jb20iLCJyb2xlIjoiYnVzaW5lc3Nfb3duZXIiLCJpYXQiOjE3NTI0Nzk4NTksImV4cCI6MTc1MjU2NjI1OX0.LArx4C7AhN6VFONYFahqjmk4_SJw6SjTsddah6sRt7A',
        },
      );

      log('Update status response: ${response.data}');

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
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c3JfMTIzNDU2Nzg5MCIsImVtYWlsIjoib3duZXJAZXhhbXBsZS5jb20iLCJyb2xlIjoiYnVzaW5lc3Nfb3duZXIiLCJpYXQiOjE3NTI0Nzk4NTksImV4cCI6MTc1MjU2NjI1OX0.LArx4C7AhN6VFONYFahqjmk4_SJw6SjTsddah6sRt7A',
        },
      );

      log('Reject order response: ${response.data}');

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
}
