import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/get_branch_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@injectable
class GetBranchDataUsecase {
  HomeRepo homeRepo;
  GetBranchDataUsecase(this.homeRepo);

  Future<Either<Failures, GetBranchResponseModel>> call() =>
      homeRepo.getBranchesData();
}
