import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:revesion/mainArea/docs.dart';
import 'package:revesion/mainArea/notifications.dart';
import 'package:revesion/mainArea/selection.dart';
import 'package:revesion/settings&profile/profile.dart';

class CustomNavBar extends StatelessWidget {
  final int navIndex;
  const CustomNavBar({super.key, required this.navIndex});

  void _onTap(BuildContext context, int index) {
    if (index == navIndex) return;
    late Widget dest;
    switch (index) {
      case 0:
        dest = const SelectOption();
        break;
      case 1:
        dest = const Documents();
        break;
      case 2:
        dest = const NotificationsPage();
        break;
      case 3:
        dest = const Profile();
        break;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => dest),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE5F9EE),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GNav(
        gap: 8,
        activeColor: Colors.black,
        color: Colors.grey[800],
        iconSize: 28,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 800),
        tabBackgroundColor: Colors.white,
        selectedIndex: navIndex,
        onTabChange: (idx) => _onTap(context, idx),
        tabs: const [
          GButton(
            icon: Icons.home_rounded,
            text: 'Home',
          ),
          GButton(
            icon: Icons.article,
            text: 'Documents',
          ),
          GButton(
            icon: Icons.notification_add,
            text: 'Notifications',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}
