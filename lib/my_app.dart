import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_workflow_mobileapp/config/router/go_router_config.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/notification_service.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/injectable.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _goRouter = router;

  // Cache themes to avoid recreation on every build
  static final ThemeData _arabicTheme = ThemeData().copyWith(
    textTheme: ThemeData().textTheme.apply(fontFamily: 'Cairo'),
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),
  );

  static final ThemeData _englishTheme = ThemeData().copyWith(
    textTheme: ThemeData().textTheme.apply(fontFamily: 'Poppins'),
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),
  );

  @override
  Widget build(BuildContext context) {
    // Set the navigator key for notification service
    final navigatorKey = NotificationService.navigatorKey;

    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: MaterialApp.router(
        key: navigatorKey,
        builder: FToastBuilder(),
        routerConfig: _goRouter,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: context.locale.languageCode == 'ar'
            ? _arabicTheme
            : _englishTheme,
      ),
    );
  }
}
