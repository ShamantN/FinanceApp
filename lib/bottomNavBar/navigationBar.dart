import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int navIndex;
  final Function(int) onTabChange;

  const CustomNavBar({
    super.key,
    required this.navIndex,
    required this.onTabChange,
  });
//color: Color(0xFFE5F9EE),
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFE5F9EE), borderRadius: BorderRadius.circular(32)),
        child: GNav(
          tabActiveBorder: Border(
              top: BorderSide(color: Colors.black, width: 2),
              bottom: BorderSide(color: Colors.black, width: 2),
              left: BorderSide(color: Colors.black, width: 2),
              right: BorderSide(color: Colors.black, width: 2)),
          rippleColor: Colors.greenAccent,
          gap: 8,
          activeColor: Colors.black,
          color: Colors.grey[800],
          iconSize: 28,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey,
          selectedIndex: navIndex,
          onTabChange: onTabChange, // Use the callback
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
      ),
    );
  }
}
