import 'package:dartz/dartz.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';

abstract class HomeRepo {
  Future<Either<Failures, List<OrderModel>>> getOrdersData();
  Future<Either<Failures, void>> updateOrderStatus(
    String orderId,
    String status,
  );
}
