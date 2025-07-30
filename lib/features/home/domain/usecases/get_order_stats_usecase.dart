import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_stats_response_mode.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@injectable
class GetOrderStatsUseCase {
  HomeRepo homeRepo;
  GetOrderStatsUseCase(this.homeRepo);

  Future<Either<Failures, OrderStatsReponseModel>> call() =>
      homeRepo.getOrderStats();
}
