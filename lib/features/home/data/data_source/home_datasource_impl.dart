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
}
