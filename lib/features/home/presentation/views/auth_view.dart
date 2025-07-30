import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/device_utils.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  String deviceId = '';
  String? deviceToken;
  @override
  void initState() {
    super.initState();
    _initDeviceAndListenForNotifications();
  }

  Future<void> _initDeviceAndListenForNotifications() async {
    try {
      // Get device ID first
      deviceId = await DeviceUtils.getDeviceId();
      log('Device ID: $deviceId');

      // First check if device is already linked
      _checkIfLinked();

      // Get FCM token in parallel
      try {
        deviceToken = await FirebaseMessaging.instance.getToken();
        log('FCM Token: $deviceToken');
      } catch (e) {
        log('Error getting FCM token: $e');
      }

      // Set up notification listeners
      _setupNotificationListeners();
    } catch (e) {
      log('Error in AuthView init: $e');
    }
  }

  void _setupNotificationListeners() {
    // Listen for notifications when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      // Check if this is a device linked notification
      if (message.data['title'] == 'Device Linked' && mounted) {
        log('Device linked notification received, refreshing link status');
        _checkIfLinked();
      }
    });

    // Handle notification when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null &&
          message.data['title'] == 'Device Linked' &&
          mounted) {
        log('Initial message indicates device was linked');
        _checkIfLinked();
      }
    });

    // Handle notification when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['title'] == 'Device Linked' && mounted) {
        log('App opened from background with device linked notification');
        _checkIfLinked();
      }
    });
  }

  void _checkIfLinked() {
    if (mounted && deviceId.isNotEmpty) {
      log('Checking if device is linked...');
      context.read<HomeBloc>().add(HomeEvent.isLinked(deviceId));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the HomeBloc state changes
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // Handle isLinked status changes
        if (state.isLinkedStatus == ResponseStatus.success &&
            state.isLinked != null) {
          if (state.isLinked!.status == 'LINKED' &&
              state.isLinked!.accessToken != null) {
            GoRouter.of(context).go(GoRouterConfig.homeView);
          }
        }
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [Image.asset('assets/ryze-logo.png')],
              ),
            ),
            SizedBox(height: 50),
            BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state.initDeviceStatus == ResponseStatus.failure) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text(state.initDeviceFailures!.message)),
                  // );
                }
              },
              builder: (context, state) {
                if (state.initDeviceStatus == ResponseStatus.loading) {
                  return Expanded(
                    child: Center(
                      child: Lottie.asset('assets/loading.json', width: 150),
                    ),
                  );
                }
                var model = state.deviceInit;
                final code = model?.verificationCode?.replaceAll(' ', '') ?? '';
                final formattedCode = code.length > 3
                    ? '${code.substring(0, 3)}-${code.substring(3)}'
                    : 'Tap below to generate';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Column(
                    spacing: 50,
                    children: [
                      Image.asset('assets/auth-ic.png'),
                      Text(
                        textAlign: TextAlign.center,
                        'To activate your store, enter this number in your dashboard.',
                        style: TextStyle(fontSize: 31.51),
                      ),
                      Text(
                        formattedCode,
                        style: TextStyle(
                          fontSize: formattedCode == 'Tap below to generate'
                              ? 20
                              : 61.5,
                        ),
                      ),
                      SizedBox(
                        width: 363,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () async {
                            final deviceId = await DeviceUtils.getDeviceId();
                            setState(() {
                              context.read<HomeBloc>().add(
                                HomeEvent.initDevice(deviceId, deviceToken),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                'Generate code',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/icons/arrcounter-ic.svg',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Spacer(),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Powered By ',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                  Image.asset('assets/footer-logo.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
