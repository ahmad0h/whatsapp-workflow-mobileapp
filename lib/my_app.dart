import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/injectable.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _goRouter = router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: MaterialApp.router(
        builder: (context, child) {
          // Scale down UI for tablets to prevent oversized elements
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;

          // Calculate aspect ratio
          final aspectRatio = screenHeight / screenWidth;

          // Detect Honor Pad 7x (5:3 ratio = 1.666...) or similar tablets
          // 1340/800 = 1.675, so check if ratio is close to 5:3
          final is5to3Ratio = (aspectRatio - 1.666).abs() < 0.05;
          final isTabletSize = screenWidth >= 600 && screenWidth <= 900;
          final isTargetDevice = is5to3Ratio && isTabletSize;

          // Apply scaling factor for Honor Pad 7x
          final scaleFactor = isTargetDevice ? 0.85 : 1.0;

          final constrainedMediaQuery = mediaQuery.copyWith(
            textScaler: TextScaler.linear(scaleFactor),
            devicePixelRatio: mediaQuery.devicePixelRatio / scaleFactor,
          );

          return MediaQuery(
            data: constrainedMediaQuery,
            child: FToastBuilder()(context, child),
          );
        },
        routerConfig: _goRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Color(0xFFF3F3F3),
        ),
      ),
    );
  }
}
