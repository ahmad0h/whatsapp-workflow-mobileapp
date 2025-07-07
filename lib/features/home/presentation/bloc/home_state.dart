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
  }) = _HomeState;
}
