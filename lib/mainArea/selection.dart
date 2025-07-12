// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revesion/details/HI.dart';
import 'package:revesion/details/LI.dart';
import 'package:revesion/details/PO.dart';
import 'package:revesion/details/VI.dart';
import 'package:revesion/details/bank.dart';
import 'package:revesion/settings&profile/profile.dart';
import 'package:revesion/settings&profile/settings.dart';
import 'selectionWidgets.dart';

class SelectOption extends StatefulWidget {
  const SelectOption({super.key});

  @override
  State<SelectOption> createState() => _SelectOptionState();
}

enum MenuOptions { profile, settings, logout }

class _SelectOptionState extends State<SelectOption> {
  List<String> images = [
    "assets/photos/bank.jpg",
    "assets/photos/PO.png",
    "assets/photos/HI.png",
    "assets/photos/LI.png",
    "assets/photos/VI.png",
    "assets/photos/nothing.png"
  ];

  List<Widget> files = [
    BankDetailsPage(),
    PostOffice(),
    HealthInsurance(),
    LifeInsurance(),
    VehicleInsurance()
  ];

  int navIdex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 18,
          selectedIconTheme: IconThemeData(size: 30),
          fixedColor: Colors.black,
          onTap: (index) {
            setState(() {
              navIdex = index;
            });
          },
          currentIndex: navIdex,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.grey[500],
              icon: Icon(
                Icons.home_rounded,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon: Icon(Icons.article),
                label: 'Documents'),
            BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon: Icon(Icons.notification_add),
                label: 'Notifications'),
            BottomNavigationBarItem(
                backgroundColor: Colors.grey,
                icon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 78, 125, 150),
        appBar: AppBar(
          actions: [
            PopupMenuButton<MenuOptions>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 12,
                popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut),
                offset: Offset(-20, 30),
                constraints: BoxConstraints(maxWidth: 300, minWidth: 150),
                iconColor: Colors.black,
                color: Colors.grey,
                icon: Icon(Icons.more_vert),
                tooltip: 'Open Menu',
                onSelected: (MenuOptions choice) {
                  switch (choice) {
                    case MenuOptions.profile:
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Profile()));
                      break;

                    case MenuOptions.settings:
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Settings()));
                      break;

                    case MenuOptions.logout:
                      FirebaseAuth.instance.signOut();
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                      PopupMenuItem<MenuOptions>(
                          value: MenuOptions.profile,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_2,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Profile",
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                      PopupMenuItem<MenuOptions>(
                          value: MenuOptions.settings,
                          child: Row(
                            children: [
                              Icon(Icons.settings, color: Colors.black),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Settings",
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                      PopupMenuItem<MenuOptions>(
                          value: MenuOptions.logout,
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.black),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Log out",
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ))
                    ])
          ],
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
            color: Colors.black,
            tooltip: "Quick Profile",
          ),
          title: Text("All your personal finance details in one place"),
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30),
          backgroundColor: Colors.grey,
          elevation: 10,
          shadowColor: Colors.black,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFF4A90E2), // Vivid Sky Blue
            Color(0xFF007AFF), // iOS Blue
            Color(0xFF0039A6), // Deep Royal Blue
          ], stops: [
            0.0,
            0.5,
            1.0
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Center(
              child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/photos/finManager.png',
                            width: 150,
                            height: 150,
                          ),
                          Text(
                            "Your Personal Finance Manager",
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                          Text(
                            "Keep track of all your expenses, never be late for due dates and short-handed.",
                            style: TextStyle(
                                fontFamily: 'Helvetica', color: Colors.white60),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                  flex: 2,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Options(
                            title: "Banking Details",
                            imgPath: images[0],
                            filePath: files[0],
                          ),
                          Options(
                              title: "Post Office",
                              imgPath: images[1],
                              filePath: files[1]),
                          Options(
                              title: "Health Insurace",
                              imgPath: images[2],
                              filePath: files[2])
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Options(
                              title: "Life Insurance",
                              imgPath: images[3],
                              filePath: files[3]),
                          Options(
                              title: "Vehicle Insurance",
                              imgPath: images[4],
                              filePath: files[4]),
                          Options(
                            title: "Redundant",
                            imgPath: images[5],
                            filePath: files[0],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ))
            ],
          )),
        ));
  }
}
