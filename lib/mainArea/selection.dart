// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revesion/bottomNavBar/navigationBar.dart';
import 'package:revesion/details/HI.dart';
import 'package:revesion/details/LI.dart';
import 'package:revesion/details/PO.dart';
import 'package:revesion/details/VI.dart';
import 'package:revesion/details/bank.dart';
import 'package:revesion/details/expenseTracker.dart';
import 'package:revesion/settings&profile/profile.dart';
import 'package:revesion/settings&profile/settings.dart';
import 'package:revesion/details/altInvestment.dart';
import 'selectionWidgets.dart';

class SelectOption extends StatefulWidget {
  const SelectOption({super.key});

  @override
  State<SelectOption> createState() => _SelectOptionState();
}

enum MenuOptions { profile, settings, logout }

class _SelectOptionState extends State<SelectOption> {
  final List<String> images = [
    "assets/photos/bank.jpg",
    "assets/photos/PO.png",
    "assets/photos/HI.png",
    "assets/photos/LI.png",
    "assets/photos/VI.png",
    "assets/photos/nothing.png"
  ];

  final List<Widget> files = [
    BankDetailsPage(),
    PostOfficeInvestmentDetails(),
    HealthInsuranceDetails(),
    LifeInsuranceDetails(),
    VehicleInsuranceDetails(),
    AlternateInvestmentDetails()
  ];

  Future<void>? _localeChangeFuture; // Track the locale change Future

  @override
  void initState() {
    super.initState();
    _localeChangeFuture = Future.value(); // Initial value to avoid null
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _localeChangeFuture = context.setLocale(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(navIndex: 0),
      backgroundColor: const Color.fromARGB(255, 172, 198, 187),
      appBar: AppBar(
        actions: [
          PopupMenuButton<MenuOptions>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 12,
            popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut),
            offset: const Offset(-20, 30),
            constraints: const BoxConstraints(maxWidth: 300, minWidth: 150),
            iconColor: Colors.black,
            color: Colors.grey,
            icon: const Icon(Icons.more_vert),
            tooltip: 'tooltip_menu'.tr(),
            onSelected: (MenuOptions choice) {
              switch (choice) {
                case MenuOptions.profile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Profile()),
                  );
                  break;
                case MenuOptions.settings:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Settings()),
                  );
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
                    Icon(Icons.person_2, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      "menu_profile",
                      style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ],
                ),
              ),
              PopupMenuItem<MenuOptions>(
                value: MenuOptions.settings,
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      "menu_settings",
                      style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ],
                ),
              ),
              PopupMenuItem<MenuOptions>(
                value: MenuOptions.logout,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      "menu_logout",
                      style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ],
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
          color: Colors.black,
          tooltip: "tooltip_menu".tr(),
        ),
        title: const Text("select_option_title").tr(),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 30,
        ),
        backgroundColor: const Color(0xFF00C172),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder<void>(
        future: _localeChangeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            decoration: const BoxDecoration(color: Color(0xFF00C172)),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: const Color(0xFF00C172),
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/photos/finManager.png',
                              width: 150,
                              height: 150,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FinanceTrackerPage()));
                                },
                                child: Text("Expense Tracker"))
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      ),
                      child: Container(
                        color: const Color.fromARGB(255, 172, 198, 187),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Options(
                                  title: "option_banking_details".tr(),
                                  imgPath: images[0],
                                  filePath: files[0],
                                ),
                                Options(
                                  title: "option_post_office".tr(),
                                  imgPath: images[1],
                                  filePath: files[1],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Options(
                                  title: "option_health_insurance".tr(),
                                  imgPath: images[2],
                                  filePath: files[2],
                                ),
                                Options(
                                  title: "option_life_insurance".tr(),
                                  imgPath: images[3],
                                  filePath: files[3],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Options(
                                  title: "option_vehicle_insurance".tr(),
                                  imgPath: images[4],
                                  filePath: files[4],
                                ),
                                Options(
                                  title: "option_alt_investments".tr(),
                                  imgPath: images[0],
                                  filePath: files[5],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
