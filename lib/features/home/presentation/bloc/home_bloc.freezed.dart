// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetOrdersData value)?  getOrdersData,TResult Function( _UpdateOrderStatus value)?  updateOrderStatus,TResult Function( _RejectOrder value)?  rejectOrder,TResult Function( _GetOrderStats value)?  getOrderStats,TResult Function( _InitDevice value)?  initDevice,TResult Function( _IsLinked value)?  isLinked,TResult Function( _GetOrdersDataByBranchIdAndDate value)?  getOrdersDataByBranchIdAndDate,TResult Function( _GetBranchData value)?  getBranchData,TResult Function( _UpdateBranchOrderingStatus value)?  updateBranchOrderingStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetOrdersData() when getOrdersData != null:
return getOrdersData(_that);case _UpdateOrderStatus() when updateOrderStatus != null:
return updateOrderStatus(_that);case _RejectOrder() when rejectOrder != null:
return rejectOrder(_that);case _GetOrderStats() when getOrderStats != null:
return getOrderStats(_that);case _InitDevice() when initDevice != null:
return initDevice(_that);case _IsLinked() when isLinked != null:
return isLinked(_that);case _GetOrdersDataByBranchIdAndDate() when getOrdersDataByBranchIdAndDate != null:
return getOrdersDataByBranchIdAndDate(_that);case _GetBranchData() when getBranchData != null:
return getBranchData(_that);case _UpdateBranchOrderingStatus() when updateBranchOrderingStatus != null:
return updateBranchOrderingStatus(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetOrdersData value)  getOrdersData,required TResult Function( _UpdateOrderStatus value)  updateOrderStatus,required TResult Function( _RejectOrder value)  rejectOrder,required TResult Function( _GetOrderStats value)  getOrderStats,required TResult Function( _InitDevice value)  initDevice,required TResult Function( _IsLinked value)  isLinked,required TResult Function( _GetOrdersDataByBranchIdAndDate value)  getOrdersDataByBranchIdAndDate,required TResult Function( _GetBranchData value)  getBranchData,required TResult Function( _UpdateBranchOrderingStatus value)  updateBranchOrderingStatus,}){
final _that = this;
switch (_that) {
case _GetOrdersData():
return getOrdersData(_that);case _UpdateOrderStatus():
return updateOrderStatus(_that);case _RejectOrder():
return rejectOrder(_that);case _GetOrderStats():
return getOrderStats(_that);case _InitDevice():
return initDevice(_that);case _IsLinked():
return isLinked(_that);case _GetOrdersDataByBranchIdAndDate():
return getOrdersDataByBranchIdAndDate(_that);case _GetBranchData():
return getBranchData(_that);case _UpdateBranchOrderingStatus():
return updateBranchOrderingStatus(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetOrdersData value)?  getOrdersData,TResult? Function( _UpdateOrderStatus value)?  updateOrderStatus,TResult? Function( _RejectOrder value)?  rejectOrder,TResult? Function( _GetOrderStats value)?  getOrderStats,TResult? Function( _InitDevice value)?  initDevice,TResult? Function( _IsLinked value)?  isLinked,TResult? Function( _GetOrdersDataByBranchIdAndDate value)?  getOrdersDataByBranchIdAndDate,TResult? Function( _GetBranchData value)?  getBranchData,TResult? Function( _UpdateBranchOrderingStatus value)?  updateBranchOrderingStatus,}){
final _that = this;
switch (_that) {
case _GetOrdersData() when getOrdersData != null:
return getOrdersData(_that);case _UpdateOrderStatus() when updateOrderStatus != null:
return updateOrderStatus(_that);case _RejectOrder() when rejectOrder != null:
return rejectOrder(_that);case _GetOrderStats() when getOrderStats != null:
return getOrderStats(_that);case _InitDevice() when initDevice != null:
return initDevice(_that);case _IsLinked() when isLinked != null:
return isLinked(_that);case _GetOrdersDataByBranchIdAndDate() when getOrdersDataByBranchIdAndDate != null:
return getOrdersDataByBranchIdAndDate(_that);case _GetBranchData() when getBranchData != null:
return getBranchData(_that);case _UpdateBranchOrderingStatus() when updateBranchOrderingStatus != null:
return updateBranchOrderingStatus(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getOrdersData,TResult Function( String orderId,  String status)?  updateOrderStatus,TResult Function( String orderId,  String reason)?  rejectOrder,TResult Function()?  getOrderStats,TResult Function( String deviceId,  String deviceToken,  String deviceName)?  initDevice,TResult Function( String deviceId)?  isLinked,TResult Function( String date)?  getOrdersDataByBranchIdAndDate,TResult Function()?  getBranchData,TResult Function( String branchId,  String status)?  updateBranchOrderingStatus,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetOrdersData() when getOrdersData != null:
return getOrdersData();case _UpdateOrderStatus() when updateOrderStatus != null:
return updateOrderStatus(_that.orderId,_that.status);case _RejectOrder() when rejectOrder != null:
return rejectOrder(_that.orderId,_that.reason);case _GetOrderStats() when getOrderStats != null:
return getOrderStats();case _InitDevice() when initDevice != null:
return initDevice(_that.deviceId,_that.deviceToken,_that.deviceName);case _IsLinked() when isLinked != null:
return isLinked(_that.deviceId);case _GetOrdersDataByBranchIdAndDate() when getOrdersDataByBranchIdAndDate != null:
return getOrdersDataByBranchIdAndDate(_that.date);case _GetBranchData() when getBranchData != null:
return getBranchData();case _UpdateBranchOrderingStatus() when updateBranchOrderingStatus != null:
return updateBranchOrderingStatus(_that.branchId,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getOrdersData,required TResult Function( String orderId,  String status)  updateOrderStatus,required TResult Function( String orderId,  String reason)  rejectOrder,required TResult Function()  getOrderStats,required TResult Function( String deviceId,  String deviceToken,  String deviceName)  initDevice,required TResult Function( String deviceId)  isLinked,required TResult Function( String date)  getOrdersDataByBranchIdAndDate,required TResult Function()  getBranchData,required TResult Function( String branchId,  String status)  updateBranchOrderingStatus,}) {final _that = this;
switch (_that) {
case _GetOrdersData():
return getOrdersData();case _UpdateOrderStatus():
return updateOrderStatus(_that.orderId,_that.status);case _RejectOrder():
return rejectOrder(_that.orderId,_that.reason);case _GetOrderStats():
return getOrderStats();case _InitDevice():
return initDevice(_that.deviceId,_that.deviceToken,_that.deviceName);case _IsLinked():
return isLinked(_that.deviceId);case _GetOrdersDataByBranchIdAndDate():
return getOrdersDataByBranchIdAndDate(_that.date);case _GetBranchData():
return getBranchData();case _UpdateBranchOrderingStatus():
return updateBranchOrderingStatus(_that.branchId,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getOrdersData,TResult? Function( String orderId,  String status)?  updateOrderStatus,TResult? Function( String orderId,  String reason)?  rejectOrder,TResult? Function()?  getOrderStats,TResult? Function( String deviceId,  String deviceToken,  String deviceName)?  initDevice,TResult? Function( String deviceId)?  isLinked,TResult? Function( String date)?  getOrdersDataByBranchIdAndDate,TResult? Function()?  getBranchData,TResult? Function( String branchId,  String status)?  updateBranchOrderingStatus,}) {final _that = this;
switch (_that) {
case _GetOrdersData() when getOrdersData != null:
return getOrdersData();case _UpdateOrderStatus() when updateOrderStatus != null:
return updateOrderStatus(_that.orderId,_that.status);case _RejectOrder() when rejectOrder != null:
return rejectOrder(_that.orderId,_that.reason);case _GetOrderStats() when getOrderStats != null:
return getOrderStats();case _InitDevice() when initDevice != null:
return initDevice(_that.deviceId,_that.deviceToken,_that.deviceName);case _IsLinked() when isLinked != null:
return isLinked(_that.deviceId);case _GetOrdersDataByBranchIdAndDate() when getOrdersDataByBranchIdAndDate != null:
return getOrdersDataByBranchIdAndDate(_that.date);case _GetBranchData() when getBranchData != null:
return getBranchData();case _UpdateBranchOrderingStatus() when updateBranchOrderingStatus != null:
return updateBranchOrderingStatus(_that.branchId,_that.status);case _:
  return null;

}
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


class _RejectOrder implements HomeEvent {
  const _RejectOrder({required this.orderId, required this.reason});
  

 final  String orderId;
 final  String reason;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RejectOrderCopyWith<_RejectOrder> get copyWith => __$RejectOrderCopyWithImpl<_RejectOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RejectOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,reason);

@override
String toString() {
  return 'HomeEvent.rejectOrder(orderId: $orderId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RejectOrderCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$RejectOrderCopyWith(_RejectOrder value, $Res Function(_RejectOrder) _then) = __$RejectOrderCopyWithImpl;
@useResult
$Res call({
 String orderId, String reason
});




}
/// @nodoc
class __$RejectOrderCopyWithImpl<$Res>
    implements _$RejectOrderCopyWith<$Res> {
  __$RejectOrderCopyWithImpl(this._self, this._then);

  final _RejectOrder _self;
  final $Res Function(_RejectOrder) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? reason = null,}) {
  return _then(_RejectOrder(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _GetOrderStats implements HomeEvent {
  const _GetOrderStats();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetOrderStats);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.getOrderStats()';
}


}




/// @nodoc


class _InitDevice implements HomeEvent {
  const _InitDevice(this.deviceId, this.deviceToken, this.deviceName);
  

 final  String deviceId;
 final  String deviceToken;
 final  String deviceName;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitDeviceCopyWith<_InitDevice> get copyWith => __$InitDeviceCopyWithImpl<_InitDevice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitDevice&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceToken, deviceToken) || other.deviceToken == deviceToken)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName));
}


@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceToken,deviceName);

@override
String toString() {
  return 'HomeEvent.initDevice(deviceId: $deviceId, deviceToken: $deviceToken, deviceName: $deviceName)';
}


}

/// @nodoc
abstract mixin class _$InitDeviceCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$InitDeviceCopyWith(_InitDevice value, $Res Function(_InitDevice) _then) = __$InitDeviceCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceToken, String deviceName
});




}
/// @nodoc
class __$InitDeviceCopyWithImpl<$Res>
    implements _$InitDeviceCopyWith<$Res> {
  __$InitDeviceCopyWithImpl(this._self, this._then);

  final _InitDevice _self;
  final $Res Function(_InitDevice) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceToken = null,Object? deviceName = null,}) {
  return _then(_InitDevice(
null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,null == deviceToken ? _self.deviceToken : deviceToken // ignore: cast_nullable_to_non_nullable
as String,null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _IsLinked implements HomeEvent {
  const _IsLinked(this.deviceId);
  

 final  String deviceId;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IsLinkedCopyWith<_IsLinked> get copyWith => __$IsLinkedCopyWithImpl<_IsLinked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IsLinked&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}


@override
int get hashCode => Object.hash(runtimeType,deviceId);

@override
String toString() {
  return 'HomeEvent.isLinked(deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$IsLinkedCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$IsLinkedCopyWith(_IsLinked value, $Res Function(_IsLinked) _then) = __$IsLinkedCopyWithImpl;
@useResult
$Res call({
 String deviceId
});




}
/// @nodoc
class __$IsLinkedCopyWithImpl<$Res>
    implements _$IsLinkedCopyWith<$Res> {
  __$IsLinkedCopyWithImpl(this._self, this._then);

  final _IsLinked _self;
  final $Res Function(_IsLinked) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceId = null,}) {
  return _then(_IsLinked(
null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _GetOrdersDataByBranchIdAndDate implements HomeEvent {
  const _GetOrdersDataByBranchIdAndDate(this.date);
  

 final  String date;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetOrdersDataByBranchIdAndDateCopyWith<_GetOrdersDataByBranchIdAndDate> get copyWith => __$GetOrdersDataByBranchIdAndDateCopyWithImpl<_GetOrdersDataByBranchIdAndDate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetOrdersDataByBranchIdAndDate&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,date);

@override
String toString() {
  return 'HomeEvent.getOrdersDataByBranchIdAndDate(date: $date)';
}


}

/// @nodoc
abstract mixin class _$GetOrdersDataByBranchIdAndDateCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$GetOrdersDataByBranchIdAndDateCopyWith(_GetOrdersDataByBranchIdAndDate value, $Res Function(_GetOrdersDataByBranchIdAndDate) _then) = __$GetOrdersDataByBranchIdAndDateCopyWithImpl;
@useResult
$Res call({
 String date
});




}
/// @nodoc
class __$GetOrdersDataByBranchIdAndDateCopyWithImpl<$Res>
    implements _$GetOrdersDataByBranchIdAndDateCopyWith<$Res> {
  __$GetOrdersDataByBranchIdAndDateCopyWithImpl(this._self, this._then);

  final _GetOrdersDataByBranchIdAndDate _self;
  final $Res Function(_GetOrdersDataByBranchIdAndDate) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(_GetOrdersDataByBranchIdAndDate(
null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _GetBranchData implements HomeEvent {
  const _GetBranchData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetBranchData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.getBranchData()';
}


}




/// @nodoc


class _UpdateBranchOrderingStatus implements HomeEvent {
  const _UpdateBranchOrderingStatus(this.branchId, this.status);
  

 final  String branchId;
 final  String status;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateBranchOrderingStatusCopyWith<_UpdateBranchOrderingStatus> get copyWith => __$UpdateBranchOrderingStatusCopyWithImpl<_UpdateBranchOrderingStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateBranchOrderingStatus&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,branchId,status);

@override
String toString() {
  return 'HomeEvent.updateBranchOrderingStatus(branchId: $branchId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateBranchOrderingStatusCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$UpdateBranchOrderingStatusCopyWith(_UpdateBranchOrderingStatus value, $Res Function(_UpdateBranchOrderingStatus) _then) = __$UpdateBranchOrderingStatusCopyWithImpl;
@useResult
$Res call({
 String branchId, String status
});




}
/// @nodoc
class __$UpdateBranchOrderingStatusCopyWithImpl<$Res>
    implements _$UpdateBranchOrderingStatusCopyWith<$Res> {
  __$UpdateBranchOrderingStatusCopyWithImpl(this._self, this._then);

  final _UpdateBranchOrderingStatus _self;
  final $Res Function(_UpdateBranchOrderingStatus) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? status = null,}) {
  return _then(_UpdateBranchOrderingStatus(
null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$HomeState {

 ResponseStatus get getOrdersListStatus; Failures? get getOrdersListFailures; List<OrderModel>? get ordersList; List<OrderCardModel>? get processedOrdersList; ResponseStatus get updateOrderStatus; Failures? get updateOrderStatusFailures; ResponseStatus get rejectOrderStatus; Failures? get rejectOrderFailures; ResponseStatus get getOrderStatsStatus; Failures? get getOrderStatsFailures; OrderStatsReponseModel? get orderStats; ResponseStatus get initDeviceStatus; Failures? get initDeviceFailures; DeviceInitReponseModel? get deviceInit; ResponseStatus get isLinkedStatus; Failures? get isLinkedFailures; IsLinkedReponseModel? get isLinked; ResponseStatus get getOrdersDataByBranchIdAndDateStatus; Failures? get getOrdersDataByBranchIdAndDateFailures; List<OrderModel>? get getOrdersDataByBranchIdAndDate; ResponseStatus get getBranchesDataStatus; Failures? get getBranchesDataFailures; GetBranchResponseModel? get getBranchesData; ResponseStatus get updateBranchOrderingStatusStatus; Failures? get updateBranchOrderingStatusFailures; UpdateBranchOrderingStatusResponseModel? get updateBranchOrderingStatus;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.getOrdersListStatus, getOrdersListStatus) || other.getOrdersListStatus == getOrdersListStatus)&&(identical(other.getOrdersListFailures, getOrdersListFailures) || other.getOrdersListFailures == getOrdersListFailures)&&const DeepCollectionEquality().equals(other.ordersList, ordersList)&&const DeepCollectionEquality().equals(other.processedOrdersList, processedOrdersList)&&(identical(other.updateOrderStatus, updateOrderStatus) || other.updateOrderStatus == updateOrderStatus)&&(identical(other.updateOrderStatusFailures, updateOrderStatusFailures) || other.updateOrderStatusFailures == updateOrderStatusFailures)&&(identical(other.rejectOrderStatus, rejectOrderStatus) || other.rejectOrderStatus == rejectOrderStatus)&&(identical(other.rejectOrderFailures, rejectOrderFailures) || other.rejectOrderFailures == rejectOrderFailures)&&(identical(other.getOrderStatsStatus, getOrderStatsStatus) || other.getOrderStatsStatus == getOrderStatsStatus)&&(identical(other.getOrderStatsFailures, getOrderStatsFailures) || other.getOrderStatsFailures == getOrderStatsFailures)&&(identical(other.orderStats, orderStats) || other.orderStats == orderStats)&&(identical(other.initDeviceStatus, initDeviceStatus) || other.initDeviceStatus == initDeviceStatus)&&(identical(other.initDeviceFailures, initDeviceFailures) || other.initDeviceFailures == initDeviceFailures)&&(identical(other.deviceInit, deviceInit) || other.deviceInit == deviceInit)&&(identical(other.isLinkedStatus, isLinkedStatus) || other.isLinkedStatus == isLinkedStatus)&&(identical(other.isLinkedFailures, isLinkedFailures) || other.isLinkedFailures == isLinkedFailures)&&(identical(other.isLinked, isLinked) || other.isLinked == isLinked)&&(identical(other.getOrdersDataByBranchIdAndDateStatus, getOrdersDataByBranchIdAndDateStatus) || other.getOrdersDataByBranchIdAndDateStatus == getOrdersDataByBranchIdAndDateStatus)&&(identical(other.getOrdersDataByBranchIdAndDateFailures, getOrdersDataByBranchIdAndDateFailures) || other.getOrdersDataByBranchIdAndDateFailures == getOrdersDataByBranchIdAndDateFailures)&&const DeepCollectionEquality().equals(other.getOrdersDataByBranchIdAndDate, getOrdersDataByBranchIdAndDate)&&(identical(other.getBranchesDataStatus, getBranchesDataStatus) || other.getBranchesDataStatus == getBranchesDataStatus)&&(identical(other.getBranchesDataFailures, getBranchesDataFailures) || other.getBranchesDataFailures == getBranchesDataFailures)&&(identical(other.getBranchesData, getBranchesData) || other.getBranchesData == getBranchesData)&&(identical(other.updateBranchOrderingStatusStatus, updateBranchOrderingStatusStatus) || other.updateBranchOrderingStatusStatus == updateBranchOrderingStatusStatus)&&(identical(other.updateBranchOrderingStatusFailures, updateBranchOrderingStatusFailures) || other.updateBranchOrderingStatusFailures == updateBranchOrderingStatusFailures)&&(identical(other.updateBranchOrderingStatus, updateBranchOrderingStatus) || other.updateBranchOrderingStatus == updateBranchOrderingStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,getOrdersListStatus,getOrdersListFailures,const DeepCollectionEquality().hash(ordersList),const DeepCollectionEquality().hash(processedOrdersList),updateOrderStatus,updateOrderStatusFailures,rejectOrderStatus,rejectOrderFailures,getOrderStatsStatus,getOrderStatsFailures,orderStats,initDeviceStatus,initDeviceFailures,deviceInit,isLinkedStatus,isLinkedFailures,isLinked,getOrdersDataByBranchIdAndDateStatus,getOrdersDataByBranchIdAndDateFailures,const DeepCollectionEquality().hash(getOrdersDataByBranchIdAndDate),getBranchesDataStatus,getBranchesDataFailures,getBranchesData,updateBranchOrderingStatusStatus,updateBranchOrderingStatusFailures,updateBranchOrderingStatus]);

@override
String toString() {
  return 'HomeState(getOrdersListStatus: $getOrdersListStatus, getOrdersListFailures: $getOrdersListFailures, ordersList: $ordersList, processedOrdersList: $processedOrdersList, updateOrderStatus: $updateOrderStatus, updateOrderStatusFailures: $updateOrderStatusFailures, rejectOrderStatus: $rejectOrderStatus, rejectOrderFailures: $rejectOrderFailures, getOrderStatsStatus: $getOrderStatsStatus, getOrderStatsFailures: $getOrderStatsFailures, orderStats: $orderStats, initDeviceStatus: $initDeviceStatus, initDeviceFailures: $initDeviceFailures, deviceInit: $deviceInit, isLinkedStatus: $isLinkedStatus, isLinkedFailures: $isLinkedFailures, isLinked: $isLinked, getOrdersDataByBranchIdAndDateStatus: $getOrdersDataByBranchIdAndDateStatus, getOrdersDataByBranchIdAndDateFailures: $getOrdersDataByBranchIdAndDateFailures, getOrdersDataByBranchIdAndDate: $getOrdersDataByBranchIdAndDate, getBranchesDataStatus: $getBranchesDataStatus, getBranchesDataFailures: $getBranchesDataFailures, getBranchesData: $getBranchesData, updateBranchOrderingStatusStatus: $updateBranchOrderingStatusStatus, updateBranchOrderingStatusFailures: $updateBranchOrderingStatusFailures, updateBranchOrderingStatus: $updateBranchOrderingStatus)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 ResponseStatus getOrdersListStatus, Failures? getOrdersListFailures, List<OrderModel>? ordersList, List<OrderCardModel>? processedOrdersList, ResponseStatus updateOrderStatus, Failures? updateOrderStatusFailures, ResponseStatus rejectOrderStatus, Failures? rejectOrderFailures, ResponseStatus getOrderStatsStatus, Failures? getOrderStatsFailures, OrderStatsReponseModel? orderStats, ResponseStatus initDeviceStatus, Failures? initDeviceFailures, DeviceInitReponseModel? deviceInit, ResponseStatus isLinkedStatus, Failures? isLinkedFailures, IsLinkedReponseModel? isLinked, ResponseStatus getOrdersDataByBranchIdAndDateStatus, Failures? getOrdersDataByBranchIdAndDateFailures, List<OrderModel>? getOrdersDataByBranchIdAndDate, ResponseStatus getBranchesDataStatus, Failures? getBranchesDataFailures, GetBranchResponseModel? getBranchesData, ResponseStatus updateBranchOrderingStatusStatus, Failures? updateBranchOrderingStatusFailures, UpdateBranchOrderingStatusResponseModel? updateBranchOrderingStatus
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
@pragma('vm:prefer-inline') @override $Res call({Object? getOrdersListStatus = null,Object? getOrdersListFailures = freezed,Object? ordersList = freezed,Object? processedOrdersList = freezed,Object? updateOrderStatus = null,Object? updateOrderStatusFailures = freezed,Object? rejectOrderStatus = null,Object? rejectOrderFailures = freezed,Object? getOrderStatsStatus = null,Object? getOrderStatsFailures = freezed,Object? orderStats = freezed,Object? initDeviceStatus = null,Object? initDeviceFailures = freezed,Object? deviceInit = freezed,Object? isLinkedStatus = null,Object? isLinkedFailures = freezed,Object? isLinked = freezed,Object? getOrdersDataByBranchIdAndDateStatus = null,Object? getOrdersDataByBranchIdAndDateFailures = freezed,Object? getOrdersDataByBranchIdAndDate = freezed,Object? getBranchesDataStatus = null,Object? getBranchesDataFailures = freezed,Object? getBranchesData = freezed,Object? updateBranchOrderingStatusStatus = null,Object? updateBranchOrderingStatusFailures = freezed,Object? updateBranchOrderingStatus = freezed,}) {
  return _then(_self.copyWith(
getOrdersListStatus: null == getOrdersListStatus ? _self.getOrdersListStatus : getOrdersListStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrdersListFailures: freezed == getOrdersListFailures ? _self.getOrdersListFailures : getOrdersListFailures // ignore: cast_nullable_to_non_nullable
as Failures?,ordersList: freezed == ordersList ? _self.ordersList : ordersList // ignore: cast_nullable_to_non_nullable
as List<OrderModel>?,processedOrdersList: freezed == processedOrdersList ? _self.processedOrdersList : processedOrdersList // ignore: cast_nullable_to_non_nullable
as List<OrderCardModel>?,updateOrderStatus: null == updateOrderStatus ? _self.updateOrderStatus : updateOrderStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,updateOrderStatusFailures: freezed == updateOrderStatusFailures ? _self.updateOrderStatusFailures : updateOrderStatusFailures // ignore: cast_nullable_to_non_nullable
as Failures?,rejectOrderStatus: null == rejectOrderStatus ? _self.rejectOrderStatus : rejectOrderStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,rejectOrderFailures: freezed == rejectOrderFailures ? _self.rejectOrderFailures : rejectOrderFailures // ignore: cast_nullable_to_non_nullable
as Failures?,getOrderStatsStatus: null == getOrderStatsStatus ? _self.getOrderStatsStatus : getOrderStatsStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrderStatsFailures: freezed == getOrderStatsFailures ? _self.getOrderStatsFailures : getOrderStatsFailures // ignore: cast_nullable_to_non_nullable
as Failures?,orderStats: freezed == orderStats ? _self.orderStats : orderStats // ignore: cast_nullable_to_non_nullable
as OrderStatsReponseModel?,initDeviceStatus: null == initDeviceStatus ? _self.initDeviceStatus : initDeviceStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,initDeviceFailures: freezed == initDeviceFailures ? _self.initDeviceFailures : initDeviceFailures // ignore: cast_nullable_to_non_nullable
as Failures?,deviceInit: freezed == deviceInit ? _self.deviceInit : deviceInit // ignore: cast_nullable_to_non_nullable
as DeviceInitReponseModel?,isLinkedStatus: null == isLinkedStatus ? _self.isLinkedStatus : isLinkedStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,isLinkedFailures: freezed == isLinkedFailures ? _self.isLinkedFailures : isLinkedFailures // ignore: cast_nullable_to_non_nullable
as Failures?,isLinked: freezed == isLinked ? _self.isLinked : isLinked // ignore: cast_nullable_to_non_nullable
as IsLinkedReponseModel?,getOrdersDataByBranchIdAndDateStatus: null == getOrdersDataByBranchIdAndDateStatus ? _self.getOrdersDataByBranchIdAndDateStatus : getOrdersDataByBranchIdAndDateStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrdersDataByBranchIdAndDateFailures: freezed == getOrdersDataByBranchIdAndDateFailures ? _self.getOrdersDataByBranchIdAndDateFailures : getOrdersDataByBranchIdAndDateFailures // ignore: cast_nullable_to_non_nullable
as Failures?,getOrdersDataByBranchIdAndDate: freezed == getOrdersDataByBranchIdAndDate ? _self.getOrdersDataByBranchIdAndDate : getOrdersDataByBranchIdAndDate // ignore: cast_nullable_to_non_nullable
as List<OrderModel>?,getBranchesDataStatus: null == getBranchesDataStatus ? _self.getBranchesDataStatus : getBranchesDataStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getBranchesDataFailures: freezed == getBranchesDataFailures ? _self.getBranchesDataFailures : getBranchesDataFailures // ignore: cast_nullable_to_non_nullable
as Failures?,getBranchesData: freezed == getBranchesData ? _self.getBranchesData : getBranchesData // ignore: cast_nullable_to_non_nullable
as GetBranchResponseModel?,updateBranchOrderingStatusStatus: null == updateBranchOrderingStatusStatus ? _self.updateBranchOrderingStatusStatus : updateBranchOrderingStatusStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,updateBranchOrderingStatusFailures: freezed == updateBranchOrderingStatusFailures ? _self.updateBranchOrderingStatusFailures : updateBranchOrderingStatusFailures // ignore: cast_nullable_to_non_nullable
as Failures?,updateBranchOrderingStatus: freezed == updateBranchOrderingStatus ? _self.updateBranchOrderingStatus : updateBranchOrderingStatus // ignore: cast_nullable_to_non_nullable
as UpdateBranchOrderingStatusResponseModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ResponseStatus getOrdersListStatus,  Failures? getOrdersListFailures,  List<OrderModel>? ordersList,  List<OrderCardModel>? processedOrdersList,  ResponseStatus updateOrderStatus,  Failures? updateOrderStatusFailures,  ResponseStatus rejectOrderStatus,  Failures? rejectOrderFailures,  ResponseStatus getOrderStatsStatus,  Failures? getOrderStatsFailures,  OrderStatsReponseModel? orderStats,  ResponseStatus initDeviceStatus,  Failures? initDeviceFailures,  DeviceInitReponseModel? deviceInit,  ResponseStatus isLinkedStatus,  Failures? isLinkedFailures,  IsLinkedReponseModel? isLinked,  ResponseStatus getOrdersDataByBranchIdAndDateStatus,  Failures? getOrdersDataByBranchIdAndDateFailures,  List<OrderModel>? getOrdersDataByBranchIdAndDate,  ResponseStatus getBranchesDataStatus,  Failures? getBranchesDataFailures,  GetBranchResponseModel? getBranchesData,  ResponseStatus updateBranchOrderingStatusStatus,  Failures? updateBranchOrderingStatusFailures,  UpdateBranchOrderingStatusResponseModel? updateBranchOrderingStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.getOrdersListStatus,_that.getOrdersListFailures,_that.ordersList,_that.processedOrdersList,_that.updateOrderStatus,_that.updateOrderStatusFailures,_that.rejectOrderStatus,_that.rejectOrderFailures,_that.getOrderStatsStatus,_that.getOrderStatsFailures,_that.orderStats,_that.initDeviceStatus,_that.initDeviceFailures,_that.deviceInit,_that.isLinkedStatus,_that.isLinkedFailures,_that.isLinked,_that.getOrdersDataByBranchIdAndDateStatus,_that.getOrdersDataByBranchIdAndDateFailures,_that.getOrdersDataByBranchIdAndDate,_that.getBranchesDataStatus,_that.getBranchesDataFailures,_that.getBranchesData,_that.updateBranchOrderingStatusStatus,_that.updateBranchOrderingStatusFailures,_that.updateBranchOrderingStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ResponseStatus getOrdersListStatus,  Failures? getOrdersListFailures,  List<OrderModel>? ordersList,  List<OrderCardModel>? processedOrdersList,  ResponseStatus updateOrderStatus,  Failures? updateOrderStatusFailures,  ResponseStatus rejectOrderStatus,  Failures? rejectOrderFailures,  ResponseStatus getOrderStatsStatus,  Failures? getOrderStatsFailures,  OrderStatsReponseModel? orderStats,  ResponseStatus initDeviceStatus,  Failures? initDeviceFailures,  DeviceInitReponseModel? deviceInit,  ResponseStatus isLinkedStatus,  Failures? isLinkedFailures,  IsLinkedReponseModel? isLinked,  ResponseStatus getOrdersDataByBranchIdAndDateStatus,  Failures? getOrdersDataByBranchIdAndDateFailures,  List<OrderModel>? getOrdersDataByBranchIdAndDate,  ResponseStatus getBranchesDataStatus,  Failures? getBranchesDataFailures,  GetBranchResponseModel? getBranchesData,  ResponseStatus updateBranchOrderingStatusStatus,  Failures? updateBranchOrderingStatusFailures,  UpdateBranchOrderingStatusResponseModel? updateBranchOrderingStatus)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.getOrdersListStatus,_that.getOrdersListFailures,_that.ordersList,_that.processedOrdersList,_that.updateOrderStatus,_that.updateOrderStatusFailures,_that.rejectOrderStatus,_that.rejectOrderFailures,_that.getOrderStatsStatus,_that.getOrderStatsFailures,_that.orderStats,_that.initDeviceStatus,_that.initDeviceFailures,_that.deviceInit,_that.isLinkedStatus,_that.isLinkedFailures,_that.isLinked,_that.getOrdersDataByBranchIdAndDateStatus,_that.getOrdersDataByBranchIdAndDateFailures,_that.getOrdersDataByBranchIdAndDate,_that.getBranchesDataStatus,_that.getBranchesDataFailures,_that.getBranchesData,_that.updateBranchOrderingStatusStatus,_that.updateBranchOrderingStatusFailures,_that.updateBranchOrderingStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ResponseStatus getOrdersListStatus,  Failures? getOrdersListFailures,  List<OrderModel>? ordersList,  List<OrderCardModel>? processedOrdersList,  ResponseStatus updateOrderStatus,  Failures? updateOrderStatusFailures,  ResponseStatus rejectOrderStatus,  Failures? rejectOrderFailures,  ResponseStatus getOrderStatsStatus,  Failures? getOrderStatsFailures,  OrderStatsReponseModel? orderStats,  ResponseStatus initDeviceStatus,  Failures? initDeviceFailures,  DeviceInitReponseModel? deviceInit,  ResponseStatus isLinkedStatus,  Failures? isLinkedFailures,  IsLinkedReponseModel? isLinked,  ResponseStatus getOrdersDataByBranchIdAndDateStatus,  Failures? getOrdersDataByBranchIdAndDateFailures,  List<OrderModel>? getOrdersDataByBranchIdAndDate,  ResponseStatus getBranchesDataStatus,  Failures? getBranchesDataFailures,  GetBranchResponseModel? getBranchesData,  ResponseStatus updateBranchOrderingStatusStatus,  Failures? updateBranchOrderingStatusFailures,  UpdateBranchOrderingStatusResponseModel? updateBranchOrderingStatus)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.getOrdersListStatus,_that.getOrdersListFailures,_that.ordersList,_that.processedOrdersList,_that.updateOrderStatus,_that.updateOrderStatusFailures,_that.rejectOrderStatus,_that.rejectOrderFailures,_that.getOrderStatsStatus,_that.getOrderStatsFailures,_that.orderStats,_that.initDeviceStatus,_that.initDeviceFailures,_that.deviceInit,_that.isLinkedStatus,_that.isLinkedFailures,_that.isLinked,_that.getOrdersDataByBranchIdAndDateStatus,_that.getOrdersDataByBranchIdAndDateFailures,_that.getOrdersDataByBranchIdAndDate,_that.getBranchesDataStatus,_that.getBranchesDataFailures,_that.getBranchesData,_that.updateBranchOrderingStatusStatus,_that.updateBranchOrderingStatusFailures,_that.updateBranchOrderingStatus);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.getOrdersListStatus = ResponseStatus.init, this.getOrdersListFailures, final  List<OrderModel>? ordersList, final  List<OrderCardModel>? processedOrdersList, this.updateOrderStatus = ResponseStatus.init, this.updateOrderStatusFailures, this.rejectOrderStatus = ResponseStatus.init, this.rejectOrderFailures, this.getOrderStatsStatus = ResponseStatus.init, this.getOrderStatsFailures, this.orderStats, this.initDeviceStatus = ResponseStatus.init, this.initDeviceFailures, this.deviceInit, this.isLinkedStatus = ResponseStatus.init, this.isLinkedFailures, this.isLinked, this.getOrdersDataByBranchIdAndDateStatus = ResponseStatus.init, this.getOrdersDataByBranchIdAndDateFailures, final  List<OrderModel>? getOrdersDataByBranchIdAndDate, this.getBranchesDataStatus = ResponseStatus.init, this.getBranchesDataFailures, this.getBranchesData, this.updateBranchOrderingStatusStatus = ResponseStatus.init, this.updateBranchOrderingStatusFailures, this.updateBranchOrderingStatus}): _ordersList = ordersList,_processedOrdersList = processedOrdersList,_getOrdersDataByBranchIdAndDate = getOrdersDataByBranchIdAndDate;
  

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

 final  List<OrderCardModel>? _processedOrdersList;
@override List<OrderCardModel>? get processedOrdersList {
  final value = _processedOrdersList;
  if (value == null) return null;
  if (_processedOrdersList is EqualUnmodifiableListView) return _processedOrdersList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  ResponseStatus updateOrderStatus;
@override final  Failures? updateOrderStatusFailures;
@override@JsonKey() final  ResponseStatus rejectOrderStatus;
@override final  Failures? rejectOrderFailures;
@override@JsonKey() final  ResponseStatus getOrderStatsStatus;
@override final  Failures? getOrderStatsFailures;
@override final  OrderStatsReponseModel? orderStats;
@override@JsonKey() final  ResponseStatus initDeviceStatus;
@override final  Failures? initDeviceFailures;
@override final  DeviceInitReponseModel? deviceInit;
@override@JsonKey() final  ResponseStatus isLinkedStatus;
@override final  Failures? isLinkedFailures;
@override final  IsLinkedReponseModel? isLinked;
@override@JsonKey() final  ResponseStatus getOrdersDataByBranchIdAndDateStatus;
@override final  Failures? getOrdersDataByBranchIdAndDateFailures;
 final  List<OrderModel>? _getOrdersDataByBranchIdAndDate;
@override List<OrderModel>? get getOrdersDataByBranchIdAndDate {
  final value = _getOrdersDataByBranchIdAndDate;
  if (value == null) return null;
  if (_getOrdersDataByBranchIdAndDate is EqualUnmodifiableListView) return _getOrdersDataByBranchIdAndDate;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  ResponseStatus getBranchesDataStatus;
@override final  Failures? getBranchesDataFailures;
@override final  GetBranchResponseModel? getBranchesData;
@override@JsonKey() final  ResponseStatus updateBranchOrderingStatusStatus;
@override final  Failures? updateBranchOrderingStatusFailures;
@override final  UpdateBranchOrderingStatusResponseModel? updateBranchOrderingStatus;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.getOrdersListStatus, getOrdersListStatus) || other.getOrdersListStatus == getOrdersListStatus)&&(identical(other.getOrdersListFailures, getOrdersListFailures) || other.getOrdersListFailures == getOrdersListFailures)&&const DeepCollectionEquality().equals(other._ordersList, _ordersList)&&const DeepCollectionEquality().equals(other._processedOrdersList, _processedOrdersList)&&(identical(other.updateOrderStatus, updateOrderStatus) || other.updateOrderStatus == updateOrderStatus)&&(identical(other.updateOrderStatusFailures, updateOrderStatusFailures) || other.updateOrderStatusFailures == updateOrderStatusFailures)&&(identical(other.rejectOrderStatus, rejectOrderStatus) || other.rejectOrderStatus == rejectOrderStatus)&&(identical(other.rejectOrderFailures, rejectOrderFailures) || other.rejectOrderFailures == rejectOrderFailures)&&(identical(other.getOrderStatsStatus, getOrderStatsStatus) || other.getOrderStatsStatus == getOrderStatsStatus)&&(identical(other.getOrderStatsFailures, getOrderStatsFailures) || other.getOrderStatsFailures == getOrderStatsFailures)&&(identical(other.orderStats, orderStats) || other.orderStats == orderStats)&&(identical(other.initDeviceStatus, initDeviceStatus) || other.initDeviceStatus == initDeviceStatus)&&(identical(other.initDeviceFailures, initDeviceFailures) || other.initDeviceFailures == initDeviceFailures)&&(identical(other.deviceInit, deviceInit) || other.deviceInit == deviceInit)&&(identical(other.isLinkedStatus, isLinkedStatus) || other.isLinkedStatus == isLinkedStatus)&&(identical(other.isLinkedFailures, isLinkedFailures) || other.isLinkedFailures == isLinkedFailures)&&(identical(other.isLinked, isLinked) || other.isLinked == isLinked)&&(identical(other.getOrdersDataByBranchIdAndDateStatus, getOrdersDataByBranchIdAndDateStatus) || other.getOrdersDataByBranchIdAndDateStatus == getOrdersDataByBranchIdAndDateStatus)&&(identical(other.getOrdersDataByBranchIdAndDateFailures, getOrdersDataByBranchIdAndDateFailures) || other.getOrdersDataByBranchIdAndDateFailures == getOrdersDataByBranchIdAndDateFailures)&&const DeepCollectionEquality().equals(other._getOrdersDataByBranchIdAndDate, _getOrdersDataByBranchIdAndDate)&&(identical(other.getBranchesDataStatus, getBranchesDataStatus) || other.getBranchesDataStatus == getBranchesDataStatus)&&(identical(other.getBranchesDataFailures, getBranchesDataFailures) || other.getBranchesDataFailures == getBranchesDataFailures)&&(identical(other.getBranchesData, getBranchesData) || other.getBranchesData == getBranchesData)&&(identical(other.updateBranchOrderingStatusStatus, updateBranchOrderingStatusStatus) || other.updateBranchOrderingStatusStatus == updateBranchOrderingStatusStatus)&&(identical(other.updateBranchOrderingStatusFailures, updateBranchOrderingStatusFailures) || other.updateBranchOrderingStatusFailures == updateBranchOrderingStatusFailures)&&(identical(other.updateBranchOrderingStatus, updateBranchOrderingStatus) || other.updateBranchOrderingStatus == updateBranchOrderingStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,getOrdersListStatus,getOrdersListFailures,const DeepCollectionEquality().hash(_ordersList),const DeepCollectionEquality().hash(_processedOrdersList),updateOrderStatus,updateOrderStatusFailures,rejectOrderStatus,rejectOrderFailures,getOrderStatsStatus,getOrderStatsFailures,orderStats,initDeviceStatus,initDeviceFailures,deviceInit,isLinkedStatus,isLinkedFailures,isLinked,getOrdersDataByBranchIdAndDateStatus,getOrdersDataByBranchIdAndDateFailures,const DeepCollectionEquality().hash(_getOrdersDataByBranchIdAndDate),getBranchesDataStatus,getBranchesDataFailures,getBranchesData,updateBranchOrderingStatusStatus,updateBranchOrderingStatusFailures,updateBranchOrderingStatus]);

@override
String toString() {
  return 'HomeState(getOrdersListStatus: $getOrdersListStatus, getOrdersListFailures: $getOrdersListFailures, ordersList: $ordersList, processedOrdersList: $processedOrdersList, updateOrderStatus: $updateOrderStatus, updateOrderStatusFailures: $updateOrderStatusFailures, rejectOrderStatus: $rejectOrderStatus, rejectOrderFailures: $rejectOrderFailures, getOrderStatsStatus: $getOrderStatsStatus, getOrderStatsFailures: $getOrderStatsFailures, orderStats: $orderStats, initDeviceStatus: $initDeviceStatus, initDeviceFailures: $initDeviceFailures, deviceInit: $deviceInit, isLinkedStatus: $isLinkedStatus, isLinkedFailures: $isLinkedFailures, isLinked: $isLinked, getOrdersDataByBranchIdAndDateStatus: $getOrdersDataByBranchIdAndDateStatus, getOrdersDataByBranchIdAndDateFailures: $getOrdersDataByBranchIdAndDateFailures, getOrdersDataByBranchIdAndDate: $getOrdersDataByBranchIdAndDate, getBranchesDataStatus: $getBranchesDataStatus, getBranchesDataFailures: $getBranchesDataFailures, getBranchesData: $getBranchesData, updateBranchOrderingStatusStatus: $updateBranchOrderingStatusStatus, updateBranchOrderingStatusFailures: $updateBranchOrderingStatusFailures, updateBranchOrderingStatus: $updateBranchOrderingStatus)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 ResponseStatus getOrdersListStatus, Failures? getOrdersListFailures, List<OrderModel>? ordersList, List<OrderCardModel>? processedOrdersList, ResponseStatus updateOrderStatus, Failures? updateOrderStatusFailures, ResponseStatus rejectOrderStatus, Failures? rejectOrderFailures, ResponseStatus getOrderStatsStatus, Failures? getOrderStatsFailures, OrderStatsReponseModel? orderStats, ResponseStatus initDeviceStatus, Failures? initDeviceFailures, DeviceInitReponseModel? deviceInit, ResponseStatus isLinkedStatus, Failures? isLinkedFailures, IsLinkedReponseModel? isLinked, ResponseStatus getOrdersDataByBranchIdAndDateStatus, Failures? getOrdersDataByBranchIdAndDateFailures, List<OrderModel>? getOrdersDataByBranchIdAndDate, ResponseStatus getBranchesDataStatus, Failures? getBranchesDataFailures, GetBranchResponseModel? getBranchesData, ResponseStatus updateBranchOrderingStatusStatus, Failures? updateBranchOrderingStatusFailures, UpdateBranchOrderingStatusResponseModel? updateBranchOrderingStatus
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
@override @pragma('vm:prefer-inline') $Res call({Object? getOrdersListStatus = null,Object? getOrdersListFailures = freezed,Object? ordersList = freezed,Object? processedOrdersList = freezed,Object? updateOrderStatus = null,Object? updateOrderStatusFailures = freezed,Object? rejectOrderStatus = null,Object? rejectOrderFailures = freezed,Object? getOrderStatsStatus = null,Object? getOrderStatsFailures = freezed,Object? orderStats = freezed,Object? initDeviceStatus = null,Object? initDeviceFailures = freezed,Object? deviceInit = freezed,Object? isLinkedStatus = null,Object? isLinkedFailures = freezed,Object? isLinked = freezed,Object? getOrdersDataByBranchIdAndDateStatus = null,Object? getOrdersDataByBranchIdAndDateFailures = freezed,Object? getOrdersDataByBranchIdAndDate = freezed,Object? getBranchesDataStatus = null,Object? getBranchesDataFailures = freezed,Object? getBranchesData = freezed,Object? updateBranchOrderingStatusStatus = null,Object? updateBranchOrderingStatusFailures = freezed,Object? updateBranchOrderingStatus = freezed,}) {
  return _then(_HomeState(
getOrdersListStatus: null == getOrdersListStatus ? _self.getOrdersListStatus : getOrdersListStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrdersListFailures: freezed == getOrdersListFailures ? _self.getOrdersListFailures : getOrdersListFailures // ignore: cast_nullable_to_non_nullable
as Failures?,ordersList: freezed == ordersList ? _self._ordersList : ordersList // ignore: cast_nullable_to_non_nullable
as List<OrderModel>?,processedOrdersList: freezed == processedOrdersList ? _self._processedOrdersList : processedOrdersList // ignore: cast_nullable_to_non_nullable
as List<OrderCardModel>?,updateOrderStatus: null == updateOrderStatus ? _self.updateOrderStatus : updateOrderStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,updateOrderStatusFailures: freezed == updateOrderStatusFailures ? _self.updateOrderStatusFailures : updateOrderStatusFailures // ignore: cast_nullable_to_non_nullable
as Failures?,rejectOrderStatus: null == rejectOrderStatus ? _self.rejectOrderStatus : rejectOrderStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,rejectOrderFailures: freezed == rejectOrderFailures ? _self.rejectOrderFailures : rejectOrderFailures // ignore: cast_nullable_to_non_nullable
as Failures?,getOrderStatsStatus: null == getOrderStatsStatus ? _self.getOrderStatsStatus : getOrderStatsStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrderStatsFailures: freezed == getOrderStatsFailures ? _self.getOrderStatsFailures : getOrderStatsFailures // ignore: cast_nullable_to_non_nullable
as Failures?,orderStats: freezed == orderStats ? _self.orderStats : orderStats // ignore: cast_nullable_to_non_nullable
as OrderStatsReponseModel?,initDeviceStatus: null == initDeviceStatus ? _self.initDeviceStatus : initDeviceStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,initDeviceFailures: freezed == initDeviceFailures ? _self.initDeviceFailures : initDeviceFailures // ignore: cast_nullable_to_non_nullable
as Failures?,deviceInit: freezed == deviceInit ? _self.deviceInit : deviceInit // ignore: cast_nullable_to_non_nullable
as DeviceInitReponseModel?,isLinkedStatus: null == isLinkedStatus ? _self.isLinkedStatus : isLinkedStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,isLinkedFailures: freezed == isLinkedFailures ? _self.isLinkedFailures : isLinkedFailures // ignore: cast_nullable_to_non_nullable
as Failures?,isLinked: freezed == isLinked ? _self.isLinked : isLinked // ignore: cast_nullable_to_non_nullable
as IsLinkedReponseModel?,getOrdersDataByBranchIdAndDateStatus: null == getOrdersDataByBranchIdAndDateStatus ? _self.getOrdersDataByBranchIdAndDateStatus : getOrdersDataByBranchIdAndDateStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getOrdersDataByBranchIdAndDateFailures: freezed == getOrdersDataByBranchIdAndDateFailures ? _self.getOrdersDataByBranchIdAndDateFailures : getOrdersDataByBranchIdAndDateFailures // ignore: cast_nullable_to_non_nullable
as Failures?,getOrdersDataByBranchIdAndDate: freezed == getOrdersDataByBranchIdAndDate ? _self._getOrdersDataByBranchIdAndDate : getOrdersDataByBranchIdAndDate // ignore: cast_nullable_to_non_nullable
as List<OrderModel>?,getBranchesDataStatus: null == getBranchesDataStatus ? _self.getBranchesDataStatus : getBranchesDataStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,getBranchesDataFailures: freezed == getBranchesDataFailures ? _self.getBranchesDataFailures : getBranchesDataFailures // ignore: cast_nullable_to_non_nullable
as Failures?,getBranchesData: freezed == getBranchesData ? _self.getBranchesData : getBranchesData // ignore: cast_nullable_to_non_nullable
as GetBranchResponseModel?,updateBranchOrderingStatusStatus: null == updateBranchOrderingStatusStatus ? _self.updateBranchOrderingStatusStatus : updateBranchOrderingStatusStatus // ignore: cast_nullable_to_non_nullable
as ResponseStatus,updateBranchOrderingStatusFailures: freezed == updateBranchOrderingStatusFailures ? _self.updateBranchOrderingStatusFailures : updateBranchOrderingStatusFailures // ignore: cast_nullable_to_non_nullable
as Failures?,updateBranchOrderingStatus: freezed == updateBranchOrderingStatus ? _self.updateBranchOrderingStatus : updateBranchOrderingStatus // ignore: cast_nullable_to_non_nullable
as UpdateBranchOrderingStatusResponseModel?,
  ));
}


}

// dart format on
