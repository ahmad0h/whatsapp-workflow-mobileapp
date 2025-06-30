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
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/get_order_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/domain/usecases/update_status_usecase.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';

import 'features/home/data/data_source/home_datasource.dart' as _i887;
import 'features/home/data/data_source/home_datasource_impl.dart' as _i829;
import 'features/home/data/repository/home_repo_impl.dart' as _i1072;
import 'features/home/domain/repository/home_repo.dart' as _i47;
import 'features/home/domain/usecases/get_order_usecase.dart' as _i597;
import 'features/home/domain/usecases/update_status_usecase.dart' as _i743;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i887.HomeDatasource>(() => _i829.HomeDatasourceImpl());
    gh.factory<HomeBloc>(
      () => HomeBloc(gh<GetOrdersUseCase>(), gh<UpdateStatusUseCase>()),
    );
    gh.factory<_i47.HomeRepo>(
      () => _i1072.HomeRepoImpl(gh<_i887.HomeDatasource>()),
    );
    gh.factory<_i597.GetOrdersUseCase>(
      () => _i597.GetOrdersUseCase(gh<_i47.HomeRepo>()),
    );
    gh.factory<_i743.UpdateStatusUseCase>(
      () => _i743.UpdateStatusUseCase(gh<_i47.HomeRepo>()),
    );
    return this;
  }
}
