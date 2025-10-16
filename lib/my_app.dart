import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
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
        builder: FToastBuilder(),
        routerConfig: _goRouter,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: ThemeData().copyWith(
          textTheme: context.locale.languageCode == 'ar'
              ? ThemeData().textTheme.apply(fontFamily: 'Cairo')
              : ThemeData().textTheme.apply(fontFamily: 'Poppins'),
          scaffoldBackgroundColor: Color(0xFFF3F3F3),
        ),
      ),
    );
  }
}
