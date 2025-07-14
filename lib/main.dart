import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/service_locator.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/device_utils.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/injectable.dart';
import 'dart:developer' as developer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  configureDependencies();

  try {
    final deviceId = await DeviceUtils.getDeviceId();
    developer.log('App started with device ID: $deviceId');
  } catch (e) {
    developer.log('Failed to get device ID: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _goRouter = router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: MaterialApp.router(
        routerConfig: _goRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
