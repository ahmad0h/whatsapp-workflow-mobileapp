import 'package:dartz/dartz.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/device_init_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/get_branch_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/is_linked_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_stats_response_mode.dart';

abstract class HomeRepo {
  Future<Either<Failures, List<OrderModel>>> getOrdersData();
  Future<Either<Failures, void>> updateOrderStatus(
    String orderId,
    String status,
  );
  Future<Either<Failures, void>> rejectOrder({
    required String orderId,
    required String reason,
  });
  Future<Either<Failures, OrderStatsReponseModel>> getOrderStats();
  Future<Either<Failures, DeviceInitReponseModel>> initDevice({
    required String deviceId,
    String? deviceToken,
  });
  Future<Either<Failures, IsLinkedReponseModel>> isLinked({
    required String deviceId,
  });
  Future<Either<Failures, List<OrderModel>>> getOrdersDataByBranchIdAndDate({
    required String date,
  });
  Future<Either<Failures, GetBranchResponseModel>> getBranchesData();
}
