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

  // Helper method to check if the device is in landscape mode
  bool _isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Helper method to get responsive padding
  EdgeInsets _getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return const EdgeInsets.symmetric(horizontal: 200);
    } else if (width > 800) {
      return const EdgeInsets.symmetric(horizontal: 100);
    } else if (width > 600) {
      return const EdgeInsets.symmetric(horizontal: 50);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
  }

  // Helper method to get responsive font size
  double _getResponsiveFontSize(
    BuildContext context, {
    required double baseSize,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final shortestSide = width < height ? width : height;

    if (shortestSide > 1200) {
      return baseSize * 1.5;
    } else if (shortestSide > 800) {
      return baseSize * 1.3;
    } else if (shortestSide > 600) {
      return baseSize * 1.1;
    } else {
      return baseSize;
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = _isLandscape(context);
          final isTablet = constraints.maxWidth > 600;

          return Scaffold(
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      Container(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: MediaQuery.of(context).padding.top + 16,
                          bottom: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/ryze-logo.png',
                              width: isTablet ? 200 : 150,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),

                      // Main Content
                      Expanded(
                        child: Padding(
                          padding: _getResponsivePadding(context),
                          child: BlocConsumer<HomeBloc, HomeState>(
                            listener: (context, state) {
                              if (state.initDeviceStatus ==
                                  ResponseStatus.failure) {
                                // Handle error state if needed
                              }
                            },
                            builder: (context, state) {
                              if (state.initDeviceStatus ==
                                  ResponseStatus.loading) {
                                return Center(
                                  child: Lottie.asset(
                                    'assets/loading.json',
                                    width: isTablet ? 200 : 150,
                                  ),
                                );
                              }

                              final model = state.deviceInit;
                              final code =
                                  model?.verificationCode?.replaceAll(
                                    ' ',
                                    '',
                                  ) ??
                                  '';
                              final formattedCode = code.length > 3
                                  ? '${code.substring(0, 3)}-${code.substring(3)}'
                                  : 'Tap below to generate';

                              final content = [
                                // Image
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: Image.asset(
                                    'assets/auth-ic.png',
                                    // width: isTablet ? 250 : 180,
                                    // height: isTablet ? 250 : 180,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                // Instruction Text
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: Text(
                                    'To activate your store, enter this number in your dashboard.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: _getResponsiveFontSize(
                                        context,
                                        baseSize: 16,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),

                                // Code Display
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: Text(
                                    formattedCode,
                                    style: TextStyle(
                                      fontSize: _getResponsiveFontSize(
                                        context,
                                        baseSize:
                                            formattedCode ==
                                                'Tap below to generate'
                                            ? 20.0
                                            : 40.0,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // Generate Button
                                // if (!isLandscape || !isTablet)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: SizedBox(
                                    width: isTablet ? 400 : double.infinity,
                                    height: isTablet ? 70 : 60,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final deviceId =
                                            await DeviceUtils.getDeviceId();
                                        if (context.mounted) {
                                          context.read<HomeBloc>().add(
                                            HomeEvent.initDevice(
                                              deviceId,
                                              deviceToken!,
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Generate code',
                                            style: TextStyle(
                                              fontSize: _getResponsiveFontSize(
                                                context,
                                                baseSize: 16,
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SvgPicture.asset(
                                            'assets/icons/arrcounter-ic.svg',
                                            width: 24,
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ];

                              // For landscape mode on tablets, show content side by side
                              if (isLandscape && isTablet) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Left side - Image
                                    Expanded(flex: 2, child: content[0]),

                                    // Right side - Text and Button
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: content.sublist(1),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              // For portrait mode or phones
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: content,
                              );
                            },
                          ),
                        ),
                      ),
                      // Footer Section
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Powered By ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: _getResponsiveFontSize(
                                  context,
                                  baseSize: 12,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/footer-logo.png',
                              width: isTablet ? 100 : 80,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
