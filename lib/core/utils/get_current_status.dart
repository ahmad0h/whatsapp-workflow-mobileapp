import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';

String getCurrentStatus(OrderModel order) {
  if (order.logs == null || order.logs!.isEmpty) {
    return order.status ?? '';
  }

  // Sort logs by timestamp in descending order to get the most recent first
  final sortedLogs = List<OrderLog>.from(order.logs!)
    ..sort((a, b) => (b.logTimestamp ?? '').compareTo(a.logTimestamp ?? ''));

  // Return the most recent log's status if available, otherwise fall back to order status
  return sortedLogs.first.orderStatus ?? order.status ?? '';
}
