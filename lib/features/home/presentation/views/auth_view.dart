import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
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
  String deviceName = 'Unknown Device';
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

      // Get device name
      deviceName = await DeviceUtils.getDeviceName();
      log('Device Name: $deviceName');

      // Get FCM token and generate code
      try {
        deviceToken = await FirebaseMessaging.instance.getToken();
        log('FCM Token: $deviceToken');

        // Generate code automatically after getting device token
        if (mounted && deviceToken != null) {
          context.read<HomeBloc>().add(HomeEvent.initDevice(deviceId, deviceToken!, deviceName));
        }
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
      if (message != null && message.data['title'] == 'Device Linked' && mounted) {
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
      return EdgeInsets.symmetric(horizontal: 200);
    } else if (width > 800) {
      return EdgeInsets.symmetric(horizontal: 100);
    } else if (width > 600) {
      return EdgeInsets.symmetric(horizontal: 50);
    } else {
      return EdgeInsets.symmetric(horizontal: 24);
    }
  }

  // Helper method to get responsive font size
  double _getResponsiveFontSize(BuildContext context, {required double baseSize}) {
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
        if (state.isLinkedStatus == ResponseStatus.success && state.isLinked != null) {
          if (state.isLinked!.status == 'LINKED' && state.isLinked!.accessToken != null) {
            GoRouter.of(context).go(GoRouterConfig.homeView);
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = _isLandscape(context);
          final isTablet = constraints.maxWidth > 600;
          final isArabic = context.locale == const Locale('ar');
          return Stack(
            children: [
              Scaffold(
                body: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header Section
                                // Container(
                                //   padding: EdgeInsets.only(
                                //     left: 24,
                                //     right: 24,
                                //     top: MediaQuery.of(context).padding.top + 16,
                                //     bottom: 16,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     gradient: LinearGradient(
                                //       begin: Alignment.centerLeft,
                                //       end: Alignment.centerRight,
                                //       colors: [AppColors.primary, AppColors.primaryDark],
                                //     ),
                                // Main Content
                                Expanded(
                                  child: Padding(
                                    padding: _getResponsivePadding(context),
                                    child: BlocConsumer<HomeBloc, HomeState>(
                                      listener: (context, state) {
                                        if (state.initDeviceStatus == ResponseStatus.failure) {
                                          // Handle error state if needed
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state.initDeviceStatus == ResponseStatus.loading) {
                                          return Center(
                                            child: Lottie.asset(
                                              'assets/loading.json',
                                              width: isTablet ? 200 : 150,
                                            ),
                                          );
                                        }

                                        final model = state.deviceInit;
                                        final code =
                                            model?.verificationCode?.replaceAll(' ', '') ?? '';
                                        final formattedCode = code.length > 3
                                            ? '${code.substring(0, 3)}-${code.substring(3)}'
                                            : 'auth.tapToGenerate'.tr();

                                        final content = [
                                          // Image
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 32.0),
                                            child: Image.asset(
                                              'assets/auth-ic.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),

                                          // Instruction Text
                                          Container(
                                            padding: EdgeInsets.only(bottom: 32.0),
                                            child: Text(
                                              'auth.instruction'.tr(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: _getResponsiveFontSize(
                                                  context,
                                                  baseSize: 26,
                                                ),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),

                                          // Code Display
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 32.0),
                                            child: Text(
                                              formattedCode,
                                              style: TextStyle(
                                                fontSize: _getResponsiveFontSize(
                                                  context,
                                                  baseSize:
                                                      formattedCode == 'auth.tapToGenerate'.tr()
                                                      ? 20.0
                                                      : 61.42,
                                                ),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                          // Generate Button
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 32.0),
                                            child: SizedBox(
                                              width: isTablet ? 400 : double.infinity,
                                              height: isTablet ? 70 : 60,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  final deviceId = await DeviceUtils.getDeviceId();
                                                  if (context.mounted) {
                                                    context.read<HomeBloc>().add(
                                                      HomeEvent.initDevice(
                                                        deviceId,
                                                        deviceToken!,
                                                        deviceName,
                                                      ),
                                                    );
                                                  }
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
                                                  children: [
                                                    Text(
                                                      'auth.generateCode'.tr(),
                                                      style: TextStyle(
                                                        fontSize: _getResponsiveFontSize(
                                                          context,
                                                          baseSize: 24,
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
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
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Left side - Image
                                              Expanded(flex: 2, child: content[0]),

                                              // Right side - Text and Button
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                //         'Powered By ',
                                //         style: TextStyle(
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: _getResponsiveFontSize(
                                //             context,
                                //             baseSize: 12,
                                //           ),
                                //         ),
                                //       ),
                                //       Image.asset(
                                //         'assets/footer-logo.png',
                                //         width: isTablet ? 100 : 80,
                                //         fit: BoxFit.contain,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            Positioned(top: 50, right: 20, child: LangSwitch(isArabic: isArabic)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: 16.0,
              //   right: 16.0,
              //   child: LanguageToggle(scale: 0.7), // Adjust scale as needed
              // ),
            ],
          );
        },
      ),
    );
  }
}

class LangSwitch extends StatelessWidget {
  const LangSwitch({super.key, required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isArabic) {
          context.setLocale(const Locale('en'));
        } else {
          context.setLocale(const Locale('ar'));
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE4E4E7), width: 1),
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(1, 3),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic ? 'English' : 'العربية',
              style: TextStyle(fontSize: 16, color: Color(0xFF343330), fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 8),
            Icon(Icons.language),
          ],
        ),
      ),
    );
  }
}
