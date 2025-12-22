import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart'
    show Failures;
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/device_init_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/get_branch_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/is_linked_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_stats_response_mode.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/update_branch_ordering_status_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/get_branch_data_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/get_order_by_branchid_date_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/get_order_stats_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/get_order_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/init_device_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/is_linked_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/reject_order_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/update_branch_ordering_status_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/update_status_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_util.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOrdersUseCase getOrdersUseCase;
  final UpdateStatusUseCase updateStatusUseCase;
  final RejectOrderUsecase rejectOrderUsecase;
  final GetOrderStatsUseCase getOrderStatsUseCase;
  final InitDeviceUsecase initDeviceUsecase;
  final IsLinkedUsecase isLinkedUsecase;
  final GetOrdersDataByBranchIdAndDateUsecase
  getOrdersDataByBranchIdAndDateUsecase;
  final GetBranchDataUsecase getBranchDataUsecase;
  final UpdateBranchOrderingStatusUsecase updateBranchOrderingStatusUsecase;
  HomeBloc(
    this.getOrdersUseCase,
    this.updateStatusUseCase,
    this.rejectOrderUsecase,
    this.getOrderStatsUseCase,
    this.initDeviceUsecase,
    this.isLinkedUsecase,
    this.getOrdersDataByBranchIdAndDateUsecase,
    this.getBranchDataUsecase,
    this.updateBranchOrderingStatusUsecase,
  ) : super(const HomeState()) {
    on<_GetOrdersData>((event, emit) async {
      emit(state.copyWith(getOrdersListStatus: ResponseStatus.loading));
      var result = await getOrdersUseCase();
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              getOrdersListStatus: ResponseStatus.failure,
              getOrdersListFailures: failure,
            ),
          );
        },
        (orderModel) {
          final processed = HomeUtils.processOrders(orderModel);
          emit(
            state.copyWith(
              getOrdersListStatus: ResponseStatus.success,
              ordersList: orderModel,
              processedOrdersList: processed,
            ),
          );
        },
      );
    });
    on<_UpdateOrderStatus>((event, emit) async {
      emit(state.copyWith(updateOrderStatus: ResponseStatus.loading));
      var result = await updateStatusUseCase(event.orderId, event.status);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              updateOrderStatus: ResponseStatus.failure,
              updateOrderStatusFailures: failure,
            ),
          );
        },
        (orderModel) {
          emit(state.copyWith(updateOrderStatus: ResponseStatus.success));
        },
      );
    });
    on<_RejectOrder>((event, emit) async {
      emit(state.copyWith(rejectOrderStatus: ResponseStatus.loading));
      var result = await rejectOrderUsecase(event.orderId, event.reason);

      await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              rejectOrderStatus: ResponseStatus.failure,
              rejectOrderFailures: failure,
            ),
          );
          // Reset status after a short delay to allow UI to show error
          await Future.delayed(const Duration(seconds: 2));
          if (state.rejectOrderStatus == ResponseStatus.failure) {
            emit(state.copyWith(rejectOrderStatus: ResponseStatus.init));
          }
        },
        (success) async {
          // First emit success
          emit(state.copyWith(rejectOrderStatus: ResponseStatus.success));

          // Then reset status and refresh orders
          await Future.delayed(const Duration(milliseconds: 500));
          add(const HomeEvent.getOrdersData());
          emit(state.copyWith(rejectOrderStatus: ResponseStatus.init));
        },
      );
    });

    on<_GetOrderStats>((event, emit) async {
      emit(state.copyWith(getOrderStatsStatus: ResponseStatus.loading));
      var result = await getOrderStatsUseCase();
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              getOrderStatsStatus: ResponseStatus.failure,
              getOrderStatsFailures: failure,
            ),
          );
        },
        (orderStats) {
          emit(
            state.copyWith(
              getOrderStatsStatus: ResponseStatus.success,
              orderStats: orderStats,
            ),
          );
        },
      );
    });
    on<_InitDevice>((event, emit) async {
      emit(state.copyWith(initDeviceStatus: ResponseStatus.loading));
      var result = await initDeviceUsecase(
        event.deviceId,
        event.deviceToken,
        event.deviceName,
      );
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              initDeviceStatus: ResponseStatus.failure,
              initDeviceFailures: failure,
            ),
          );
        },
        (deviceInit) {
          emit(
            state.copyWith(
              initDeviceStatus: ResponseStatus.success,
              deviceInit: deviceInit,
            ),
          );
        },
      );
    });
    on<_IsLinked>((event, emit) async {
      emit(state.copyWith(isLinkedStatus: ResponseStatus.loading));
      var result = await isLinkedUsecase(event.deviceId);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              isLinkedStatus: ResponseStatus.failure,
              isLinkedFailures: failure,
            ),
          );
        },
        (isLinked) {
          emit(
            state.copyWith(
              isLinkedStatus: ResponseStatus.success,
              isLinked: isLinked,
            ),
          );
        },
      );
    });
    on<_GetOrdersDataByBranchIdAndDate>((event, emit) async {
      emit(
        state.copyWith(
          getOrdersDataByBranchIdAndDateStatus: ResponseStatus.loading,
        ),
      );
      var result = await getOrdersDataByBranchIdAndDateUsecase(event.date);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              getOrdersDataByBranchIdAndDateStatus: ResponseStatus.failure,
              getOrdersDataByBranchIdAndDateFailures: failure,
            ),
          );
        },
        (orders) {
          emit(
            state.copyWith(
              getOrdersDataByBranchIdAndDateStatus: ResponseStatus.success,
              getOrdersDataByBranchIdAndDate: orders,
            ),
          );
        },
      );
    });

    on<_GetBranchData>((event, emit) async {
      emit(state.copyWith(getBranchesDataStatus: ResponseStatus.loading));
      var result = await getBranchDataUsecase();
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              getBranchesDataStatus: ResponseStatus.failure,
              getBranchesDataFailures: failure,
            ),
          );
        },
        (branches) {
          emit(
            state.copyWith(
              getBranchesDataStatus: ResponseStatus.success,
              getBranchesData: branches,
            ),
          );
        },
      );
    });

    on<_UpdateBranchOrderingStatus>((event, emit) async {
      // Update local state immediately for instant UI feedback
      final currentBranch = state.getBranchesData;
      if (currentBranch != null) {
        final updatedBranch = currentBranch.copyWith(
          orderingStatus: event.status,
        );
        emit(
          state.copyWith(
            getBranchesData: updatedBranch,
            updateBranchOrderingStatusStatus: ResponseStatus.loading,
          ),
        );
      } else {
        emit(
          state.copyWith(
            updateBranchOrderingStatusStatus: ResponseStatus.loading,
          ),
        );
      }

      // Make the API call
      final result = await updateBranchOrderingStatusUsecase(
        event.branchId,
        event.status,
      );

      // Handle the API response
      result.fold(
        (failure) {
          // If there's an error, revert the local state
          if (currentBranch != null) {
            emit(
              state.copyWith(
                getBranchesData: currentBranch,
                updateBranchOrderingStatusStatus: ResponseStatus.failure,
                updateBranchOrderingStatusFailures: failure,
              ),
            );
          } else {
            emit(
              state.copyWith(
                updateBranchOrderingStatusStatus: ResponseStatus.failure,
                updateBranchOrderingStatusFailures: failure,
              ),
            );
          }
        },
        (updateBranchOrderingStatus) {
          // On success, just update the status, keeping the optimistic update
          emit(
            state.copyWith(
              updateBranchOrderingStatusStatus: ResponseStatus.success,
              updateBranchOrderingStatus: updateBranchOrderingStatus,
            ),
          );
        },
      );
    });
  }
}
