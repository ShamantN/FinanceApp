import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/firebase_options.dart';
import 'package:revesion/models/altInvestModel.dart';
import 'package:revesion/models/bankModel.dart';
import 'package:revesion/models/document_model.dart';
import 'package:revesion/models/healthInsurance.dart';
import 'package:revesion/models/lifeInsurance.dart';
import 'package:revesion/models/postOffice.dart';
import 'package:revesion/models/transactions.dart';
import 'package:revesion/models/vehicle_insurance_model.dart';
import 'login/test.dart';
import 'mainArea/selection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // Set IST time zone

  // Request notification permission
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
    },
  );

  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'maturity_reminder_channel',
    'Maturity Reminders',
    description: 'Notifications for Post Office investment maturity reminders',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  print('Notification channel created: ${channel.id}'); // Debug log

  await Hive.initFlutter();
  Hive.registerAdapter(BankAccountModelAdapter());
  Hive.registerAdapter(PostOfficeAdapter());
  Hive.registerAdapter(LifeInsuranceAdapter());
  Hive.registerAdapter(HealthInsuranceAdapter());
  Hive.registerAdapter(VehicleInsuranceModelAdapter());
  Hive.registerAdapter(AltInvestModelAdapter());
  Hive.registerAdapter(DocumentModelAdapter());
  Hive.registerAdapter(TransactionAdapter());

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
      title: 'Your Personal Finance Manager',
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
