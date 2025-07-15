import 'package:flutter/material.dart';
import 'package:revesion/bottomNavBar/navigationBar.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomNavBar(navIndex: 1),
      backgroundColor: Colors.red,
    );
  }
}
