// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// @nodoc


class _Started implements HomeEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.started()';
}


}




/// @nodoc


class _GetOrdersData implements HomeEvent {
  const _GetOrdersData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetOrdersData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.getOrdersData()';
}


}




/// @nodoc


class _UpdateOrderStatus implements HomeEvent {
  const _UpdateOrderStatus(this.orderId, this.status);
  

 final  String orderId;
 final  String status;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateOrderStatusCopyWith<_UpdateOrderStatus> get copyWith => __$UpdateOrderStatusCopyWithImpl<_UpdateOrderStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateOrderStatus&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,status);

@override
String toString() {
  return 'HomeEvent.updateOrderStatus(orderId: $orderId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateOrderStatusCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$UpdateOrderStatusCopyWith(_UpdateOrderStatus value, $Res Function(_UpdateOrderStatus) _then) = __$UpdateOrderStatusCopyWithImpl;
@useResult
$Res call({
 String orderId, String status
});




}
/// @nodoc
class __$UpdateOrderStatusCopyWithImpl<$Res>
    implements _$UpdateOrderStatusCopyWith<$Res> {
  __$UpdateOrderStatusCopyWithImpl(this._self, this._then);

  final _UpdateOrderStatus _self;
  final $Res Function(_UpdateOrderStatus) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? status = null,}) {
  return _then(_UpdateOrderStatus(
null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$HomeState {

 ResponseStatus get getOrdersListStatus; Failures? get getOrdersListFailures; List<OrderModel>? get ordersList; ResponseStatus get updateOrderStatus; Failures? get updateOrderStatusFailures;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.getOrdersListStatus, getOrdersListStatus) || other.getOrdersListStatus == getOrdersListStatus)&&(identical(other.getOrdersListFailures, getOrdersListFailures) || other.getOrdersListFailures == getOrdersListFailures)&&const DeepCollectionEquality().equals(other.ordersList, ordersList)&&(identical(other.updateOrderStatus, updateOrderStatus) || other.updateOrderStatus == updateOrderStatus)&&(identical(other.updateOrderStatusFailures, updateOrderStatusFailures) || other.updateOrderStatusFailures == updateOrderStatusFailures));
}


@override
int get hashCode => Object.hash(runtimeType,getOrdersListStatus,getOrdersListFailures,const DeepCollectionEquality().hash(ordersList),updateOrderStatus,updateOrderStatusFailures);

@override
String toString() {
  return 'HomeState(getOrdersListStatus: $getOrdersListStatus, getOrdersListFailures: $getOrdersListFailures, ordersList: $ordersList, updateOrderStatus: $updateOrderStatus, updateOrderStatusFailures: $updateOrderStatusFailures)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 ResponseStatus getOrdersListStatus, Failures? getOrdersListFailures, List<OrderModel>? ordersList, ResponseStatus updateOrderStatus, Failures? updateOrderStatusFailures
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? getOrdersListStatus = null,Object? getOrdersListFailures = freezed,Object? ordersList = freezed,Object? updateOrderStatus = null,Object? updateOrderStatusFailures = freezed,}) {
  return _then(_self.copyWith(
getOrdersListStatus: null == getOrdersListStatus ? _self.getOrdersListStatus : getOrdersListStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrdersListFailures: freezed == getOrdersListFailures ? _self.getOrdersListFailures : getOrdersListFailures // ignore: cast_nullable_to_non_nullable
as Failures?,ordersList: freezed == ordersList ? _self.ordersList : ordersList // ignore: cast_nullable_to_non_nullable
as List<OrderModel>?,updateOrderStatus: null == updateOrderStatus ? _self.updateOrderStatus : updateOrderStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,updateOrderStatusFailures: freezed == updateOrderStatusFailures ? _self.updateOrderStatusFailures : updateOrderStatusFailures // ignore: cast_nullable_to_non_nullable
as Failures?,
  ));
}

}


/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.getOrdersListStatus = ResponseStatus.init, this.getOrdersListFailures, final  List<OrderModel>? ordersList, this.updateOrderStatus = ResponseStatus.init, this.updateOrderStatusFailures}): _ordersList = ordersList;
  

@override@JsonKey() final  ResponseStatus getOrdersListStatus;
@override final  Failures? getOrdersListFailures;
 final  List<OrderModel>? _ordersList;
@override List<OrderModel>? get ordersList {
  final value = _ordersList;
  if (value == null) return null;
  if (_ordersList is EqualUnmodifiableListView) return _ordersList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  ResponseStatus updateOrderStatus;
@override final  Failures? updateOrderStatusFailures;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.getOrdersListStatus, getOrdersListStatus) || other.getOrdersListStatus == getOrdersListStatus)&&(identical(other.getOrdersListFailures, getOrdersListFailures) || other.getOrdersListFailures == getOrdersListFailures)&&const DeepCollectionEquality().equals(other._ordersList, _ordersList)&&(identical(other.updateOrderStatus, updateOrderStatus) || other.updateOrderStatus == updateOrderStatus)&&(identical(other.updateOrderStatusFailures, updateOrderStatusFailures) || other.updateOrderStatusFailures == updateOrderStatusFailures));
}


@override
int get hashCode => Object.hash(runtimeType,getOrdersListStatus,getOrdersListFailures,const DeepCollectionEquality().hash(_ordersList),updateOrderStatus,updateOrderStatusFailures);

@override
String toString() {
  return 'HomeState(getOrdersListStatus: $getOrdersListStatus, getOrdersListFailures: $getOrdersListFailures, ordersList: $ordersList, updateOrderStatus: $updateOrderStatus, updateOrderStatusFailures: $updateOrderStatusFailures)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 ResponseStatus getOrdersListStatus, Failures? getOrdersListFailures, List<OrderModel>? ordersList, ResponseStatus updateOrderStatus, Failures? updateOrderStatusFailures
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? getOrdersListStatus = null,Object? getOrdersListFailures = freezed,Object? ordersList = freezed,Object? updateOrderStatus = null,Object? updateOrderStatusFailures = freezed,}) {
  return _then(_HomeState(
getOrdersListStatus: null == getOrdersListStatus ? _self.getOrdersListStatus : getOrdersListStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrdersListFailures: freezed == getOrdersListFailures ? _self.getOrdersListFailures : getOrdersListFailures // ignore: cast_nullable_to_non_nullable
as Failures?,ordersList: freezed == ordersList ? _self._ordersList : ordersList // ignore: cast_nullable_to_non_nullable
as List<OrderModel>?,updateOrderStatus: null == updateOrderStatus ? _self.updateOrderStatus : updateOrderStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,updateOrderStatusFailures: freezed == updateOrderStatusFailures ? _self.updateOrderStatusFailures : updateOrderStatusFailures // ignore: cast_nullable_to_non_nullable
as Failures?,
  ));
}


}

// dart format on
