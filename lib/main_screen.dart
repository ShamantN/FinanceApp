import 'package:flutter/material.dart';
import 'package:revesion/mainArea/docs.dart';
import 'package:revesion/mainArea/notifications.dart';
import 'package:revesion/mainArea/selection.dart';
import 'package:revesion/settings&profile/profile.dart';
import 'bottomNavBar/navigationBar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of tab pages, each with its own Scaffold
  final List<Widget> _pages = [
    const SelectOption(),
    const Documents(),
    const NotificationsPage(),
    const Profile(),
  ];

  Color getColor(int index) {
    Color color = const Color.fromARGB(255, 172, 198, 187);
    switch (index) {
      case 0:
        color = const Color.fromARGB(255, 172, 198, 187);
        break;

      case 1:
        color = Colors.grey;
        break;

      case 2:
        color = Colors.white;
        break;

      case 3:
        color = Color(0xFF5369D6);
        break;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor(_currentIndex),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        navIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
