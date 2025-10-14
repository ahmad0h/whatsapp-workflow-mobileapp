import 'package:whatsapp_workflow_mobileapp/features/home/data/models/device_init_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/get_branch_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/is_linked_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_stats_response_mode.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/update_branch_ordering_status_model.dart';

abstract class HomeDatasource {
  Future<List<OrderModel>> getOrdersData();
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> rejectOrder({required String orderId, required String reason});
  Future<OrderStatsReponseModel> getOrderStats();
  Future<DeviceInitReponseModel> initDevice({
    required String deviceId,
    required String deviceToken,
  });
  Future<IsLinkedReponseModel> isLinked({required String deviceId});
  Future<List<OrderModel>> getOrdersDataByBranchIdAndDate({
    required String date,
  });
  Future<GetBranchResponseModel> getBranchesData();
  Future<UpdateBranchOrderingStatusResponseModel> updateBranchOrderingStatus(
    String branchId,
    String status,
  );
  Future<Map<String, dynamic>> getDeviceByDeviceId(String deviceId);
  Future<void> updateDeviceToken({
    required String deviceId,
    required String deviceToken,
  });
}
