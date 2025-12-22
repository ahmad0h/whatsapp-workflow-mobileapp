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
  final String status;
  final Color statusColor;
  final String carBrand;
  final String plateNumber;
  final String carDetails;
  final String carColor;
  final OrderModel orderData;
  final String orderType;
  final String customerAddress;

  const OrderCardModel({
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
    required this.orderType,
    required this.customerAddress,
  });

  OrderCardModel copyWith({
    String? orderNumber,
    String? customerName,
    String? time,
    String? status,
    Color? statusColor,
    String? carBrand,
    String? plateNumber,
    String? carDetails,
    String? carColor,
    OrderModel? orderData,
    String? orderType,
    String? customerAddress,
  }) {
    return OrderCardModel(
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      time: time ?? this.time,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      carBrand: carBrand ?? this.carBrand,
      plateNumber: plateNumber ?? this.plateNumber,
      carDetails: carDetails ?? this.carDetails,
      carColor: carColor ?? this.carColor,
      orderData: orderData ?? this.orderData,
      orderType: orderType ?? this.orderType,
      customerAddress: customerAddress ?? this.customerAddress,
    );
  }
}
