import 'dart:ui';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class OrderCardModel {
  final String orderNumber;
  final String customerName;
  final String time;
  String status;
  final Color statusColor;
  final String carBrand;
  final String plateNumber;
  final String carDetails;
  final String carColor;
  final OrderModel orderData;

  OrderCardModel({
    required this.orderNumber,
    required this.customerName,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.carBrand,
    required this.plateNumber,
    required this.carDetails,
    required this.carColor,
    required this.orderData,
  });
}
