// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'features/home/data/data_source/home_datasource.dart' as _i887;
import 'features/home/data/data_source/home_datasource_impl.dart' as _i829;
import 'features/home/data/repository/home_repo_impl.dart' as _i1072;
import 'features/home/domain/repository/home_repo.dart' as _i47;
import 'features/home/domain/usecases/get_branch_data_usecase.dart' as _i333;
import 'features/home/domain/usecases/get_order_by_branchid_date_usecase.dart'
    as _i385;
import 'features/home/domain/usecases/get_order_stats_usecase.dart' as _i362;
import 'features/home/domain/usecases/get_order_usecase.dart' as _i597;
import 'features/home/domain/usecases/init_device_usecase.dart' as _i492;
import 'features/home/domain/usecases/is_linked_usecase.dart' as _i1047;
import 'features/home/domain/usecases/reject_order_usecase.dart' as _i956;
import 'features/home/domain/usecases/update_branch_ordering_status_usecase.dart'
    as _i49;
import 'features/home/domain/usecases/update_status_usecase.dart' as _i743;
import 'features/home/presentation/bloc/home_bloc.dart' as _i123;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i887.HomeDatasource>(() => _i829.HomeDatasourceImpl());
    gh.factory<_i47.HomeRepo>(
      () => _i1072.HomeRepoImpl(gh<_i887.HomeDatasource>()),
    );
    gh.factory<_i362.GetOrderStatsUseCase>(
      () => _i362.GetOrderStatsUseCase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i385.GetOrdersDataByBranchIdAndDateUsecase>(
      () => _i385.GetOrdersDataByBranchIdAndDateUsecase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i597.GetOrdersUseCase>(
      () => _i597.GetOrdersUseCase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i492.InitDeviceUsecase>(
      () => _i492.InitDeviceUsecase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i743.UpdateStatusUseCase>(
      () => _i743.UpdateStatusUseCase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i333.GetBranchDataUsecase>(
      () => _i333.GetBranchDataUsecase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i1047.IsLinkedUsecase>(
      () => _i1047.IsLinkedUsecase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i49.UpdateBranchOrderingStatusUsecase>(
      () => _i49.UpdateBranchOrderingStatusUsecase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i956.RejectOrderUsecase>(
      () => _i956.RejectOrderUsecase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i123.HomeBloc>(
      () => _i123.HomeBloc(
        gh<_i597.GetOrdersUseCase>(),
        gh<_i743.UpdateStatusUseCase>(),
        gh<_i956.RejectOrderUsecase>(),
        gh<_i362.GetOrderStatsUseCase>(),
        gh<_i492.InitDeviceUsecase>(),
        gh<_i1047.IsLinkedUsecase>(),
        gh<_i385.GetOrdersDataByBranchIdAndDateUsecase>(),
        gh<_i333.GetBranchDataUsecase>(),
        gh<_i49.UpdateBranchOrderingStatusUsecase>(),
      ),
    );
    return this;
  }
}
