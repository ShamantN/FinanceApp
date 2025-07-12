// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revesion/firebase_options.dart';
import 'package:revesion/login/signin.dart';
import 'package:revesion/settings&profile/profile.dart';
import 'login/test.dart';
import 'mainArea/selection.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // runApp by default calls this function but since we call initializeApp, WidgetsFlutterBinding wont be intialized until after the next line
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.data != null) {
              return const SelectOption();
            } else {
              return const Login();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
