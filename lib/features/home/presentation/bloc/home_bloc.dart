import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart'
    show Failures;
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/get_order_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/reject_order_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/update_status_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOrdersUseCase getOrdersUseCase;
  final UpdateStatusUseCase updateStatusUseCase;
  final RejectOrderUsecase rejectOrderUsecase;
  HomeBloc(
    this.getOrdersUseCase,
    this.updateStatusUseCase,
    this.rejectOrderUsecase,
  ) : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
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
          emit(
            state.copyWith(
              getOrdersListStatus: ResponseStatus.success,
              ordersList: orderModel,
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
  }
}
