import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_workflow_mobileapp/core/service_locator.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';
import 'package:whatsapp_workflow_mobileapp/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  configureDependencies();

  await SharedPreferences.getInstance();
  await TokenManager().init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}
