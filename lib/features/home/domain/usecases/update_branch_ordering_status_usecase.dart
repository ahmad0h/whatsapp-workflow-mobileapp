import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/update_branch_ordering_status_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@injectable
class UpdateBranchOrderingStatusUsecase {
  HomeRepo homeRepo;
  UpdateBranchOrderingStatusUsecase(this.homeRepo);

  Future<Either<Failures, UpdateBranchOrderingStatusResponseModel>> call(
    String branchId,
    String status,
  ) => homeRepo.updateBranchOrderingStatus(branchId, status);
}
