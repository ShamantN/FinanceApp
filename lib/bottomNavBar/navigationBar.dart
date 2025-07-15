import 'package:flutter/material.dart';
import 'package:revesion/mainArea/docs.dart';
import 'package:revesion/mainArea/notifications.dart';
import 'package:revesion/mainArea/selection.dart';
import 'package:revesion/settings&profile/profile.dart';

class CustomNavBar extends StatelessWidget {
  final int navIndex;
  const CustomNavBar({super.key, required this.navIndex});

  void _onTap(BuildContext context, int index) {
    if (index == navIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SelectOption()));
        break;

      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Documents()));
        break;

      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Notifications()));
        break;

      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Profile()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 18,
        selectedIconTheme: const IconThemeData(size: 30),
        fixedColor: Colors.black,
        currentIndex: navIndex,
        onTap: (index) => _onTap(context, index),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.grey[500],
            icon: const Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              backgroundColor: Colors.grey,
              icon: Icon(Icons.article),
              label: 'Documents'),
          const BottomNavigationBarItem(
              backgroundColor: Colors.grey,
              icon: Icon(Icons.notification_add),
              label: 'Notifications'),
          const BottomNavigationBarItem(
              backgroundColor: Colors.grey,
              icon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}
