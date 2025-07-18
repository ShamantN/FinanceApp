// ignore_for_file: unused_import

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/firebase_options.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/login/signin.dart';
import 'package:revesion/models/altInvestModel.dart';
import 'package:revesion/models/bankModel.dart';
import 'package:revesion/models/document_model.dart';
import 'package:revesion/models/healthInsurance.dart';
import 'package:revesion/models/lifeInsurance.dart';
import 'package:revesion/models/postOffice.dart';
import 'package:revesion/models/vehicle_insurance_model.dart';
import 'package:revesion/settings&profile/profile.dart';
import 'login/test.dart';
import 'mainArea/selection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mainArea/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization
      .ensureInitialized(); // Ensure EasyLocalization is ready
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  await NotificationService.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(BankAccountModelAdapter());
  Hive.registerAdapter(PostOfficeAdapter());
  Hive.registerAdapter(LifeInsuranceAdapter());
  Hive.registerAdapter(HealthInsuranceAdapter());
  Hive.registerAdapter(VehicleInsuranceModelAdapter());
  Hive.registerAdapter(AltInvestModelAdapter());
  Hive.registerAdapter(DocumentModelAdapter());

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('kn')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Your Personal Finance Manager', // Static title to avoid early tr()
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Error loading authentication state')),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data != null) {
            return const SelectOption();
          } else {
            return const Login();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
