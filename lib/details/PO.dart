// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/models/postOffice.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PostOfficeInvestmentDetails extends StatefulWidget {
  const PostOfficeInvestmentDetails({super.key});

  @override
  State<PostOfficeInvestmentDetails> createState() =>
      _PostOfficeInvestmentDetailsState();
}

class _PostOfficeInvestmentDetailsState
    extends State<PostOfficeInvestmentDetails> {
  final List<PostOfficeForm> _forms = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late final Box<PostOffice> _poBox;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<String> postOfficeSchemes = [
    'po_scheme_sb'.tr(),
    'po_scheme_rd'.tr(),
    'po_scheme_td'.tr(),
    'po_scheme_mis'.tr(),
    'po_scheme_scss'.tr(),
    'po_scheme_ppf'.tr(),
    'po_scheme_ssa'.tr(),
    'po_scheme_nsc'.tr(),
    'po_scheme_kvp'.tr(),
    'po_scheme_mssc'.tr(),
  ];

  final List<String> investmentCategories = [
    'po_category_savings'.tr(),
    'po_category_recurring'.tr(),
    'po_category_fixed'.tr(),
    'po_category_monthly'.tr(),
    'po_category_senior'.tr(),
    'po_category_tax'.tr(),
    'po_category_girl'.tr(),
    'po_category_certificate'.tr(),
    'po_category_doubling'.tr(),
    'po_category_women'.tr(),
  ];

  final List<String> riskLevels = [
    'po_risk_very_low'.tr(),
    'po_risk_low'.tr(),
    'po_risk_guaranteed'.tr(),
  ];

  final List<String> tenureOptions = [
    'po_tenure_1_year'.tr(),
    'po_tenure_2_years'.tr(),
    'po_tenure_3_years'.tr(),
    'po_tenure_5_years'.tr(),
    'po_tenure_10_years'.tr(),
    'po_tenure_15_years'.tr(),
    'po_tenure_21_years'.tr(),
    'po_tenure_until_maturity'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _openAndLoadBox();
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  Future<void> _openAndLoadBox() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _poBox = await HiveFunctions.openBox<PostOffice>(poBoxWithUid(uid));
    for (var key in _poBox.keys) {
      var data = _poBox.get(key);
      var form = PostOfficeForm(key, postOfficeSchemes, investmentCategories,
          riskLevels, tenureOptions);
      form.loadData(data!);
      _forms.add(form);
      if (data.maturityDate != null) {
        _scheduleMaturityNotifications(data, key);
      }
    }
    setState(() {});
  }

  void _addInvestment() {
    setState(() {
      int newKey = _forms.isEmpty
          ? 0
          : _forms.map((f) => f.key).reduce((a, b) => a > b ? a : b) + 1;
      var newForm = PostOfficeForm(newKey, postOfficeSchemes,
          investmentCategories, riskLevels, tenureOptions);
      _forms.add(newForm);
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _pageController.animateToPage(
        _forms.length - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _removeInvestment(int index) async {
    await _cancelMaturityNotifications(_forms[index].key);
    setState(() {
      _poBox.delete(_forms[index].key);
      _forms.removeAt(index);
    });
    if (_forms.isNotEmpty) {
      int newPage = (_pageController.page!.round() >= _forms.length)
          ? _forms.length - 1
          : _pageController.page!.round();
      _pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveInvestment(int index) async {
    final form = _forms[index];
    if (form.formKey.currentState!.validate()) {
      final data = form.toPostOffice();
      await _poBox.put(form.key, data);
      if (data.maturityDate != null) {
        await _scheduleMaturityNotifications(data, form.key);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text('po_save_success'.tr())),
      );
    }
  }

  Future<void> _scheduleMaturityNotifications(PostOffice data, int key) async {
    if (data.maturityDate == null) return;

    final now = tz.TZDateTime.now(tz.local);
    final maturityDate = tz.TZDateTime.from(data.maturityDate!, tz.local);

    final intervals = [
      const Duration(days: 7),
      const Duration(days: 2),
      const Duration(days: 1),
    ];

    for (var i = 0; i < intervals.length; i++) {
      final notificationTime = maturityDate.subtract(intervals[i]);
      if (notificationTime.isAfter(now)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          key * 10 + i,
          'po_maturity_notification_title'.tr(),
          'po_maturity_notification_body'
              .tr()
              .replaceAll(
                '{0}',
                data.postOfficeName,
              )
              .replaceAll(
                '{1}',
                data.accountNumber,
              )
              .replaceAll(
                '{2}',
                intervals[i].inDays.toString(),
              ),
          notificationTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'maturity_reminder_channel',
              'Maturity Reminders',
              channelDescription:
                  'Notifications for Post Office investment maturity reminders',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload:
              '${'po_maturity_notification_title'.tr()}|${'po_maturity_notification_body'.tr().replaceAll(
                    '{0}',
                    data.postOfficeName,
                  ).replaceAll(
                    '{1}',
                    data.accountNumber,
                  ).replaceAll(
                    '{2}',
                    intervals[i].inDays.toString(),
                  )}',
        );
      }
    }
  }

  Future<void> _cancelMaturityNotifications(int key) async {
    for (var i = 0; i < 3; i++) {
      await flutterLocalNotificationsPlugin.cancel(key * 10 + i);
    }
  }

  Future<void> _scheduleTestNotification() async {
    final TextEditingController postOfficeNameCtrl = TextEditingController();
    final TextEditingController accountNumberCtrl = TextEditingController();
    final TextEditingController daysCtrl = TextEditingController();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('po_test_notification'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: postOfficeNameCtrl,
              decoration:
                  InputDecoration(labelText: 'po_post_office_name'.tr()),
            ),
            TextField(
              controller: accountNumberCtrl,
              decoration: InputDecoration(labelText: 'po_account_number'.tr()),
            ),
            TextField(
              controller: daysCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'po_days'.tr()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final notificationTime = tz.TZDateTime(
                tz.local,
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              if (notificationTime.isBefore(tz.TZDateTime.now(tz.local))) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      content: Text('po_test_notification_error'.tr())),
                );
                return;
              }

              final body = 'po_maturity_notification_body'
                  .tr()
                  .replaceAll(
                    '{0}',
                    postOfficeNameCtrl.text.isEmpty
                        ? 'Test PO'
                        : postOfficeNameCtrl.text,
                  )
                  .replaceAll(
                    '{1}',
                    accountNumberCtrl.text.isEmpty
                        ? '12345'
                        : accountNumberCtrl.text,
                  )
                  .replaceAll(
                    '{2}',
                    daysCtrl.text.isEmpty ? '1' : daysCtrl.text,
                  );

              await flutterLocalNotificationsPlugin.zonedSchedule(
                9999,
                'po_maturity_notification_title'.tr(),
                body,
                notificationTime,
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'maturity_reminder_channel',
                    'Maturity Reminders',
                    channelDescription:
                        'Notifications for Post Office investment maturity reminders',
                    importance: Importance.max,
                    priority: Priority.high,
                  ),
                ),
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                payload: '${'po_maturity_notification_title'.tr()}|$body',
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    content: Text('po_test_notification_success'.tr())),
              );
            },
            child: Text('save'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var form in _forms) {
      form.dispose();
    }
    _pageController.dispose();
    _poBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 154, 197, 232),
            Color.fromARGB(255, 115, 149, 169),
            Color.fromARGB(255, 103, 149, 209),
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          toolbarHeight: 80,
          centerTitle: true,
          title: Text(
            'po_title'.tr(),
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 30,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _scheduleTestNotification,
              icon: const Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 30,
              ),
              tooltip: 'po_test_notification'.tr(),
            ),
          ],
          backgroundColor: const Color(0xFF1E90FF),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: _forms.isEmpty
                  ? Center(
                      child: Text(
                        'po_no_investments'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _forms.length,
                      itemBuilder: (context, index) {
                        return _buildInvestmentCard(index);
                      },
                    ),
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addInvestment,
          tooltip: 'Add Investment',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildInvestmentCard(int index) {
    final form = _forms[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 154, 197, 232),
            Color.fromARGB(255, 115, 149, 169),
            Color.fromARGB(255, 103, 149, 209),
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Investment ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.redAccent, size: 30),
                    onPressed: () => _removeInvestment(index),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Form(
                    key: form.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_post_office_name'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.postOfficeNameCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.local_post_office,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_post_office_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_post_office_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_post_office_address'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.postOfficeAddressCtrl,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.location_on,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_post_office_address_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_post_office_address_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_account_number'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.accountNumberCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.account_balance,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_account_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_account_number_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_scheme_type'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: form.selectedScheme,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedScheme = newVal;
                              });
                            },
                            items: form.postOfficeSchemes.map((scheme) {
                              return DropdownMenuItem<String>(
                                value: scheme,
                                child: Text(scheme,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color(0xFF1E90FF), // Matching blue
                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_scheme_type_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_scheme_type_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_investment_category'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: DropdownButtonFormField<String>(
                            value: form.selectedCategory,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedCategory = newVal;
                              });
                            },
                            items: form.investmentCategories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color(0xFF1E90FF), // Matching blue
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.category,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_investment_category_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_investment_category_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_risk_level'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: DropdownButtonFormField<String>(
                            value: form.selectedRiskLevel,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedRiskLevel = newVal;
                              });
                            },
                            items: form.riskLevels.map((risk) {
                              return DropdownMenuItem<String>(
                                value: risk,
                                child: Text(risk,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color(0xFF1E90FF), // Matching blue
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.warning,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_risk_level_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_risk_level_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_tenure'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: DropdownButtonFormField<String>(
                            value: form.selectedTenure,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedTenure = newVal;
                              });
                            },
                            items: form.tenureOptions.map((tenure) {
                              return DropdownMenuItem<String>(
                                value: tenure,
                                child: Text(tenure,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color(0xFF1E90FF), // Matching blue
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.timer, color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_tenure_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_tenure_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_nominee_name'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.nomineeCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.person, color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_nominee_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_nominee_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_investment_amount'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.investmentAmountCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.currency_rupee,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_investment_amount_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_investment_amount_error'.tr();
                              }
                              if (double.tryParse(value) == null) {
                                return 'po_investment_amount_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_current_value'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.currentValueCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.trending_up,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_current_value_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_current_value_error'.tr();
                              }
                              if (double.tryParse(value) == null) {
                                return 'po_current_value_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_opening_date'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.openingDateCtrl,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: form.openingDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  form.openingDate = picked;
                                  form.openingDateCtrl.text =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                });
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.calendar_today,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_opening_date_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_opening_date_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_maturity_date'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.maturityDateCtrl,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: form.maturityDate ??
                                    DateTime.now()
                                        .add(const Duration(days: 365)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() {
                                  form.maturityDate = picked;
                                  form.maturityDateCtrl.text =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                });
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.event, color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_maturity_date_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_maturity_date_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_interest_rate'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.interestRateCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.percent,
                                  color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_interest_rate_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'po_interest_rate_error'.tr();
                              }
                              if (double.tryParse(value) == null) {
                                return 'po_interest_rate_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'po_remarks'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.remarksCtrl,
                            maxLines: 3,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.note, color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2),
                              ),
                              labelText: 'po_remarks_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  form.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1E90FF),
                                ),
                                child: Text('po_clear_form'.tr()),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () => _saveInvestment(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1E90FF),
                                ),
                                child: Text('po_save'.tr()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostOfficeForm {
  final int key;
  final List<String> postOfficeSchemes;
  final List<String> investmentCategories;
  final List<String> riskLevels;
  final List<String> tenureOptions;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController postOfficeNameCtrl = TextEditingController();
  final TextEditingController postOfficeAddressCtrl = TextEditingController();
  final TextEditingController accountNumberCtrl = TextEditingController();
  final TextEditingController nomineeCtrl = TextEditingController();
  final TextEditingController investmentAmountCtrl = TextEditingController();
  final TextEditingController currentValueCtrl = TextEditingController();
  final TextEditingController openingDateCtrl = TextEditingController();
  final TextEditingController maturityDateCtrl = TextEditingController();
  final TextEditingController interestRateCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  String? selectedScheme;
  String? selectedCategory;
  String? selectedRiskLevel;
  String? selectedTenure;
  DateTime? openingDate;
  DateTime? maturityDate;

  PostOfficeForm(this.key, this.postOfficeSchemes, this.investmentCategories,
      this.riskLevels, this.tenureOptions);

  void loadData(PostOffice data) {
    postOfficeNameCtrl.text = data.postOfficeName;
    postOfficeAddressCtrl.text = data.postOfficeAddress;
    accountNumberCtrl.text = data.accountNumber;
    nomineeCtrl.text = data.nomineeName;
    selectedScheme =
        postOfficeSchemes.contains(data.schemeType) ? data.schemeType : null;
    selectedCategory = investmentCategories.contains(data.investmentCategory)
        ? data.investmentCategory
        : null;
    selectedRiskLevel =
        riskLevels.contains(data.riskLevel) ? data.riskLevel : null;
    selectedTenure = tenureOptions.contains(data.tenure) ? data.tenure : null;
    investmentAmountCtrl.text = data.investmentAmount.toString();
    currentValueCtrl.text = data.currentValue.toString();
    openingDate = data.openingDate;
    openingDateCtrl.text =
        "${data.openingDate.day}/${data.openingDate.month}/${data.openingDate.year}";
    maturityDate = data.maturityDate;
    if (data.maturityDate != null) {
      maturityDateCtrl.text =
          "${data.maturityDate!.day}/${data.maturityDate!.month}/${data.maturityDate!.year}";
    }
    interestRateCtrl.text = data.interestRate.toString();
    remarksCtrl.text = data.remarks ?? '';
  }

  PostOffice toPostOffice() {
    return PostOffice(
      postOfficeName: postOfficeNameCtrl.text,
      postOfficeAddress: postOfficeAddressCtrl.text,
      accountNumber: accountNumberCtrl.text,
      nomineeName: nomineeCtrl.text,
      schemeType: selectedScheme,
      investmentCategory: selectedCategory,
      riskLevel: selectedRiskLevel,
      tenure: selectedTenure,
      investmentAmount: double.parse(investmentAmountCtrl.text),
      currentValue: double.parse(currentValueCtrl.text),
      openingDate: openingDate!,
      maturityDate: maturityDate,
      interestRate: double.parse(interestRateCtrl.text),
      remarks: remarksCtrl.text,
      createdAt: DateTime.now(),
    );
  }

  void clear() {
    postOfficeNameCtrl.clear();
    postOfficeAddressCtrl.clear();
    accountNumberCtrl.clear();
    nomineeCtrl.clear();
    investmentAmountCtrl.clear();
    currentValueCtrl.clear();
    openingDateCtrl.clear();
    maturityDateCtrl.clear();
    interestRateCtrl.clear();
    remarksCtrl.clear();
    selectedScheme = null;
    selectedCategory = null;
    selectedRiskLevel = null;
    selectedTenure = null;
    openingDate = null;
    maturityDate = null;
  }

  void dispose() {
    postOfficeNameCtrl.dispose();
    postOfficeAddressCtrl.dispose();
    accountNumberCtrl.dispose();
    nomineeCtrl.dispose();
    investmentAmountCtrl.dispose();
    currentValueCtrl.dispose();
    openingDateCtrl.dispose();
    maturityDateCtrl.dispose();
    interestRateCtrl.dispose();
    remarksCtrl.dispose();
  }
}
