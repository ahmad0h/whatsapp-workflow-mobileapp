import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';

abstract class HomeDatasource {
  Future<List<OrderModel>> getOrdersData();
  Future<void> updateOrderStatus(String orderId, String status);
}
