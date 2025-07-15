import 'package:flutter/material.dart';
import 'package:revesion/bottomNavBar/navigationBar.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomNavBar(navIndex: 2),
      backgroundColor: Colors.red,
    );
  }
}
