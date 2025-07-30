import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/core/error/failures.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/device_init_response_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/repository/home_repo.dart';

@injectable
class InitDeviceUsecase {
  HomeRepo homeRepo;
  InitDeviceUsecase(this.homeRepo);

  Future<Either<Failures, DeviceInitReponseModel>> call(
    String deviceId,
    String? deviceToken,
  ) => homeRepo.initDevice(deviceId: deviceId, deviceToken: deviceToken);
}
