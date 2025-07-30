import 'dart:developer' show log;
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/data_source/home_datasource.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/device_init_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/get_branch_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/is_linked_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_stats_response_mode.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  HomeDatasource homeDS;
  HomeRepoImpl(this.homeDS);

  @override
  Future<Either<Failures, List<OrderModel>>> getOrdersData() async {
    try {
      final orders = await homeDS.getOrdersData();
      return Right(orders);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      final result = await homeDS.updateOrderStatus(orderId, status);
      return Right(result);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> rejectOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      final result = await homeDS.rejectOrder(orderId: orderId, reason: reason);
      return Right(result);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, OrderStatsReponseModel>> getOrderStats() async {
    try {
      final result = await homeDS.getOrderStats();
      return Right(result);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, DeviceInitReponseModel>> initDevice({
    required String deviceId,
    String? deviceToken,
  }) async {
    try {
      final result = await homeDS.initDevice(
        deviceId: deviceId,
        deviceToken: deviceToken,
      );
      return Right(result);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, IsLinkedReponseModel>> isLinked({
    required String deviceId,
  }) async {
    try {
      final result = await homeDS.isLinked(deviceId: deviceId);
      return Right(result);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<OrderModel>>> getOrdersDataByBranchIdAndDate({
    required String date,
  }) async {
    try {
      final result = await homeDS.getOrdersDataByBranchIdAndDate(date: date);
      return Right(result);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, GetBranchResponseModel>> getBranchesData() async {
    try {
      final result = await homeDS.getBranchesData();
      return Right(result);
    } catch (e) {
      log(e.toString());
      return Left(RemoteFailures(e.toString()));
    }
  }
}
