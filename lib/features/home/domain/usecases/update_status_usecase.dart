import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@injectable
class UpdateStatusUseCase {
  HomeRepo homeRepo;
  UpdateStatusUseCase(this.homeRepo);

  Future<Either<Failures, void>> call(String orderId, String status) =>
      homeRepo.updateOrderStatus(orderId, status);
}
