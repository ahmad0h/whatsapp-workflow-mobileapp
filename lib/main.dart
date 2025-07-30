import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_workflow_mobileapp/core/service_locator.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';
import 'package:whatsapp_workflow_mobileapp/injectable.dart';
import 'package:whatsapp_workflow_mobileapp/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  configureDependencies();

  // Initialize SharedPreferences and TokenManager
  await SharedPreferences.getInstance();
  await TokenManager().init();

  runApp(MyApp());
}
