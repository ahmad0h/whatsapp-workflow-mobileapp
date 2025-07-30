part of 'home_bloc.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(ResponseStatus.init) ResponseStatus getOrdersListStatus,
    Failures? getOrdersListFailures,
    List<OrderModel>? ordersList,
    @Default(ResponseStatus.init) ResponseStatus updateOrderStatus,
    Failures? updateOrderStatusFailures,
    @Default(ResponseStatus.init) ResponseStatus rejectOrderStatus,
    Failures? rejectOrderFailures,
    @Default(ResponseStatus.init) ResponseStatus getOrderStatsStatus,
    Failures? getOrderStatsFailures,
    OrderStatsReponseModel? orderStats,
    @Default(ResponseStatus.init) ResponseStatus initDeviceStatus,
    Failures? initDeviceFailures,
    DeviceInitReponseModel? deviceInit,
    @Default(ResponseStatus.init) ResponseStatus isLinkedStatus,
    Failures? isLinkedFailures,
    IsLinkedReponseModel? isLinked,
    @Default(ResponseStatus.init)
    ResponseStatus getOrdersDataByBranchIdAndDateStatus,
    Failures? getOrdersDataByBranchIdAndDateFailures,
    List<OrderModel>? getOrdersDataByBranchIdAndDate,
    @Default(ResponseStatus.init) ResponseStatus getBranchesDataStatus,
    Failures? getBranchesDataFailures,
    GetBranchResponseModel? getBranchesData,
  }) = _HomeState;
}
