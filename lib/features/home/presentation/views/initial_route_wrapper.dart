import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/device_utils.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/auth_view.dart';

class InitialRouteWrapper extends StatefulWidget {
  const InitialRouteWrapper({super.key});

  @override
  State<InitialRouteWrapper> createState() => _InitialRouteWrapperState();
}

class _InitialRouteWrapperState extends State<InitialRouteWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDeviceStatus();
  }

  Future<void> _checkDeviceStatus() async {
    try {
      final deviceId = await DeviceUtils.getDeviceId();
      if (mounted) {
        context.read<HomeBloc>().add(HomeEvent.isLinked(deviceId));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.isLinkedStatus == ResponseStatus.success) {
          if (state.isLinked?.status == 'LINKED' &&
              state.isLinked?.accessToken != null) {
            // Get the bloc reference before the async gap
            final homeBloc = context.read<HomeBloc>();
            
            // Navigate to home if linked
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              
              homeBloc.add(HomeEvent.getOrdersData());
              GoRouter.of(context).go(GoRouterConfig.homeView);
            });
          } else {
            // Show auth screen if not linked
            if (mounted) {
              setState(() => _isLoading = false);
            }
          }
        } else if (state.isLinkedStatus == ResponseStatus.failure) {
          // Show auth screen if there's an error checking status
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      },
      child: _isLoading
          ? Scaffold(
              body: Center(
                child: Lottie.asset('assets/loading.json', width: 150),
              ),
            )
          : const AuthView(),
    );
  }
}
