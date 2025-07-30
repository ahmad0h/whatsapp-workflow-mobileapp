import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@injectable
class GetOrdersDataByBranchIdAndDateUsecase {
  HomeRepo homeRepo;
  GetOrdersDataByBranchIdAndDateUsecase(this.homeRepo);

  Future<Either<Failures, List<OrderModel>>> call(String date) =>
      homeRepo.getOrdersDataByBranchIdAndDate(date: date);
}
