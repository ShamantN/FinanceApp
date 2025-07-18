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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const NotificationsPage()));
        break;

      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Profile()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(48), topRight: Radius.circular(48)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[800],
        selectedFontSize: 16,
        unselectedFontSize: 11,
        selectedIconTheme: const IconThemeData(size: 30),
        fixedColor: Colors.black,
        currentIndex: navIndex,
        onTap: (index) => _onTap(context, index),
        items: [
          const BottomNavigationBarItem(
            backgroundColor: Color(0xFFE5F9EE),
            icon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              backgroundColor: Color(0xFFE5F9EE),
              icon: Icon(Icons.article),
              label: 'Documents'),
          const BottomNavigationBarItem(
              backgroundColor: Color(0xFFE5F9EE),
              icon: Icon(Icons.notification_add),
              label: 'Notifications'),
          const BottomNavigationBarItem(
              backgroundColor: Color(0xFFE5F9EE),
              icon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}
