part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.getOrdersData() = _GetOrdersData;
  const factory HomeEvent.updateOrderStatus(String orderId, String status) =
      _UpdateOrderStatus;
}
