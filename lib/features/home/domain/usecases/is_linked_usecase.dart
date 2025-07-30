import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/is_linked_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@injectable
class IsLinkedUsecase {
  HomeRepo homeRepo;
  IsLinkedUsecase(this.homeRepo);

  Future<Either<Failures, IsLinkedReponseModel>> call(String deviceId) =>
      homeRepo.isLinked(deviceId: deviceId);
}
