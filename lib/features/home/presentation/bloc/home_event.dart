part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.getOrdersData() = _GetOrdersData;
  const factory HomeEvent.updateOrderStatus(String orderId, String status) =
      _UpdateOrderStatus;
  const factory HomeEvent.rejectOrder({
    required String orderId,
    required String reason,
  }) = _RejectOrder;
  const factory HomeEvent.getOrderStats() = _GetOrderStats;
  const factory HomeEvent.initDevice(String deviceId, String deviceToken) =
      _InitDevice;
  const factory HomeEvent.isLinked(String deviceId) = _IsLinked;
  const factory HomeEvent.getOrdersDataByBranchIdAndDate(String date) =
      _GetOrdersDataByBranchIdAndDate;
  const factory HomeEvent.getBranchData() = _GetBranchData;
  const factory HomeEvent.updateBranchOrderingStatus(
    String branchId,
    String status,
  ) = _UpdateBranchOrderingStatus;
}
