import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revesion/mainArea/docs.dart';
import 'package:revesion/mainArea/notifications.dart';
import 'package:revesion/mainArea/selection.dart';
import 'package:revesion/settings&profile/profile.dart';
import 'package:revesion/settings&profile/settings.dart';
import 'bottomNavBar/navigationBar.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<DocumentsState> _documentsKey = GlobalKey<DocumentsState>();

  // List of tab pages, each with its own Scaffold
  late List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      const SelectOption(),
      Documents(key: _documentsKey),
      const NotificationsPage(),
      const Profile(),
    ];
  }

  final List<AppBar> _appBars = [
    AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: const Text("select_option_title").tr(),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontFamily: 'Helvetica',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 30,
      ),
      backgroundColor: const Color(0xFF00796B),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
    AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: const Text(
        "ನನ್ನ ದಾಖಲೆಗಳು / My Documents",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: Colors.orange.shade700,
      elevation: 0,
    ),
    AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      elevation: 10,
      title: const Text(
        'select_option_title',
        style: TextStyle(fontWeight: FontWeight.bold),
      ).tr(),
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.black,
    ),
    AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      title: const Text(
        "Edit Profile",
        style: TextStyle(
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.white),
      ),
      backgroundColor: Color(0xFF0B0F33),
    ),
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
      drawerEdgeDragWidth: 75,
      drawer: Drawer(
          backgroundColor: Colors.grey[900],
          elevation: 10,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                height: 180,
                child: Center(
                    child: Image.asset(
                  'assets/photos/pf_logo.png',
                )),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.black,
                leading: Icon(
                  Icons.info,
                  size: 30,
                ),
                title: Text(
                  "About",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Settings()));
                },
                iconColor: Colors.black,
                leading: Icon(
                  Icons.settings,
                  size: 30,
                ),
                title: Text(
                  "Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height -
                      450), // Adjust height dynamically
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[900],
                          elevation: 10,
                          icon: const Icon(
                            Icons.logout,
                            size: 30,
                          ),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                                fontSize: 20),
                          ),
                          content: Text(
                              "Are you sure you want to logout? You will be required to login again."),
                          contentTextStyle: TextStyle(color: Colors.white70),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white70),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    FirebaseAuth.instance.signOut();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.red),
                                ))
                          ],
                        );
                      });
                },
                iconColor: Colors.black,
                leading: Icon(
                  Icons.logout,
                  size: 30,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      fontSize: 20),
                ),
              ),
            ],
          )),
      appBar: _appBars[_currentIndex],
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
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                final documentsState = _documentsKey.currentState;
                if (documentsState != null) {
                  documentsState.addDocument();
                }
              },
              label: const Text(
                "ದಾಖಲೆ ಸೇರಿಸಿ / Add Document",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              icon: const Icon(Icons.add, size: 24),
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              elevation: 6,
            )
          : null,
    );
  }
}
