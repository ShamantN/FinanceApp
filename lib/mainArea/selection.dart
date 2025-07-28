// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/details/HI.dart';
import 'package:revesion/details/LI.dart';
import 'package:revesion/details/PO.dart';
import 'package:revesion/details/VI.dart';
import 'package:revesion/details/bank.dart';
import 'package:revesion/details/expenseTracker.dart';
import 'package:revesion/fomatters/formats.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/models/transactions.dart';
import 'package:revesion/details/altInvestment.dart';
import 'selectionWidgets.dart';

class SelectOption extends StatefulWidget {
  const SelectOption({super.key});

  @override
  State<SelectOption> createState() => _SelectOptionState();
}

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

  double _initialBalance = 0.0;
  late Box<double> _balanceBox;
  late Box<Transaction> _transactionBox;
  List<Transaction> _transactions = [];
  bool _isDataLoaded = false;
  Future<void>? _localeChangeFuture; // Track the locale change Future

  @override
  void initState() {
    super.initState();
    _localeChangeFuture = Future.value(); // Initial value to avoid null
    _initHive();
  }

  Future<void> _initHive() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _transactionBox = await Hive.openBox<Transaction>(expenseBoxWithUid(uid));
    _balanceBox = await Hive.openBox<double>('balanceBox_$uid');
    _transactions = HiveFunctions.readData(_transactionBox);
    _initialBalance =
        _balanceBox.get('initialBalance', defaultValue: 0.0) ?? 0.0;
    setState(() {
      _isDataLoaded = true;
    });

    _transactionBox.listenable().addListener(_updateData);
    _balanceBox.listenable().addListener(_updateData);
  }

  double get _totalBalance {
    if (!_isDataLoaded) return 0.0;
    double balance = _initialBalance;
    for (var transaction in _transactions) {
      if (transaction.type == 'Income') {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  double get _monthlyExpense {
    if (!_isDataLoaded) return 0.0;
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    return _transactions
        .where((t) => t.type == 'Expense' && t.date.isAfter(startOfMonth))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void _updateData() {
    print('Listener triggered in selection.dart');
    if (mounted) {
      print('Box updated, refreshing data in selection.dart');
      setState(() {
        _transactions = HiveFunctions.readData(_transactionBox);
        _initialBalance =
            _balanceBox.get('initialBalance', defaultValue: 0.0) ?? 0.0;
        print('Updated _transactions in selection: ${_transactions.length}');
      });
    } else {
      print('Widget not mounted');
    }
  }

  @override
  void dispose() {
    _transactionBox.close();
    _balanceBox.close();
    _transactionBox.listenable().removeListener(_updateData);
    _balanceBox.listenable().removeListener(_updateData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40, top: 20),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.account_balance,
                                              size: 18,
                                              color: Colors.grey[850]),
                                          const SizedBox(width: 8),
                                          Text(
                                            'expense_tracker_total_balance'
                                                .tr(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[850]),
                                          ),
                                        ],
                                      ),
                                      if (_isDataLoaded)
                                        Text(
                                          NumberFormatter.formatIndianCurrency(
                                              _totalBalance),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 28,
                                          ),
                                        )
                                      else
                                        const CircularProgressIndicator(),
                                    ],
                                  ),
                                  VerticalDivider(
                                    indent: 2,
                                    endIndent: 2,
                                    thickness: 2,
                                    color: Colors.grey[850],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.payments,
                                              size: 18,
                                              color: Colors.grey[850]),
                                          const SizedBox(width: 8),
                                          Text(
                                            'expense_tracker_monthly_expense'
                                                .tr(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[850]),
                                          ),
                                        ],
                                      ),
                                      if (_isDataLoaded)
                                        Text(
                                          '-' +
                                              NumberFormatter
                                                  .formatIndianCurrency(
                                                      _monthlyExpense),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 16, 93, 225),
                                            fontSize: 28,
                                          ),
                                        )
                                      else
                                        const CircularProgressIndicator(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.black,
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 30, right: 30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 5,
                                  backgroundColor: Colors.grey[900],
                                  foregroundColor: Colors.white70,
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  iconSize: 20),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FinanceTrackerPage())).then((_) {
                                  _updateData();
                                });
                              },
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.receipt_long),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text('expense_tracker_button'.tr())
                                  ]))
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
    );
  }
}
