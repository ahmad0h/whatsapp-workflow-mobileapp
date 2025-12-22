import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_workflow_mobileapp/core/service_locator.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/shorebird_update_checker.dart';
import 'package:whatsapp_workflow_mobileapp/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/my_app.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await Firebase.initializeApp();

      // Initialize Firebase Crashlytics
      // Disable Crashlytics collection in debug mode (optional)
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );

      // Pass all uncaught Flutter errors to Crashlytics
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      await setupServiceLocator();
      configureDependencies();

      await SharedPreferences.getInstance();
      await TokenManager().init();

      // Check for Shorebird updates
      locator<ShorebirdUpdateChecker>().checkForUpdates();

      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: MyApp(),
        ),
      );
    },
    (error, stack) {
      // Pass all uncaught async errors to Crashlytics
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
