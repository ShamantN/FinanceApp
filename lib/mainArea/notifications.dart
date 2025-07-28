import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:easy_localization/easy_localization.dart';

// Payment Model
class PaymentReminder {
  final String id;
  final String title;
  final double amount;
  final DateTime paymentDate;
  final DateTime notificationTime;
  final String type;
  final bool isActive;

  PaymentReminder({
    required this.id,
    required this.title,
    required this.amount,
    required this.paymentDate,
    required this.notificationTime,
    required this.type,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'notificationTime': notificationTime.toIso8601String(),
      'type': type,
      'isActive': isActive,
    };
  }

  factory PaymentReminder.fromJson(Map<String, dynamic> json) {
    return PaymentReminder(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      paymentDate: DateTime.parse(json['paymentDate']),
      notificationTime: DateTime.parse(json['notificationTime']),
      type: json['type'],
      isActive: json['isActive'] ?? true,
    );
  }

  PaymentReminder copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? paymentDate,
    DateTime? notificationTime,
    String? type,
    bool? isActive,
  }) {
    return PaymentReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      notificationTime: notificationTime ?? this.notificationTime,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Notification Service
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);

    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> scheduleMonthlyNotification(
      PaymentReminder reminder) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'payment_reminders',
      'Payment Reminders',
      channelDescription: 'Monthly payment reminders for insurance and loans',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    DateTime scheduledTime = reminder.notificationTime;
    if (scheduledTime.isBefore(DateTime.now())) {
      scheduledTime = DateTime(scheduledTime.year, scheduledTime.month + 1,
          scheduledTime.day, scheduledTime.hour, scheduledTime.minute);
    }

    await _notifications.zonedSchedule(
      reminder.id.hashCode,
      '${reminder.type.toUpperCase()} Payment Due'.tr(),
      'Don\'t forget to pay ${reminder.title} - ₹${reminder.amount.toStringAsFixed(2)}'
          .tr(),
      _convertToTZDateTime(scheduledTime),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      payload: reminder.id,
    );
  }

  static tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final location = tz.local;
    return tz.TZDateTime.from(dateTime, location);
  }

  static Future<void> cancelNotification(String reminderId) async {
    await _notifications.cancel(reminderId.hashCode);
  }

  static void onNotificationReceived(String? payload) {
    if (payload != null) {
      // This would require integration with the app's state to delete the reminder
    }
  }
}

// Main Notifications Page
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<PaymentReminder> _reminders = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  String _selectedType = 'insurance';
  late Timer _cleanupTimer;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadReminders();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    final FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();
    notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          NotificationService.onNotificationReceived(response.payload);
        }
      },
    );

    _cleanupTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAndCleanPastReminders();
    });
  }

  Future<void> _initializeNotifications() async {
    await NotificationService.initialize();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getStringList('payment_reminders') ?? [];

    setState(() {
      _reminders = remindersJson
          .map((json) => PaymentReminder.fromJson(jsonDecode(json)))
          .toList();
    });
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson =
        _reminders.map((reminder) => jsonEncode(reminder.toJson())).toList();

    await prefs.setStringList('payment_reminders', remindersJson);
  }

  Future<void> _addReminder() async {
    final now = DateTime.now();
    final selectedNotificationTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('notifications_fill_all_fields').tr()),
      );
      return;
    }

    if (selectedNotificationTime.isBefore(now) ||
        selectedNotificationTime.isAtSameMomentAs(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('notifications_future_time').tr()),
      );
      return;
    }

    final newReminder = PaymentReminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      paymentDate: _selectedDate,
      notificationTime: selectedNotificationTime,
      type: _selectedType,
    );

    setState(() {
      _reminders.add(newReminder);
    });

    await _saveReminders();
    if (newReminder.isActive) {
      await NotificationService.scheduleMonthlyNotification(newReminder);
    }

    _titleController.clear();
    _amountController.clear();
    _selectedDate = DateTime.now();
    _selectedTime = DateTime.now();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text('notifications_success').tr()),
    );
  }

  Future<void> _toggleReminder(PaymentReminder reminder) async {
    final updatedReminder = reminder.copyWith(isActive: !reminder.isActive);

    setState(() {
      final index = _reminders.indexOf(reminder);
      _reminders[index] = updatedReminder;
    });

    await _saveReminders();

    if (updatedReminder.isActive &&
        updatedReminder.notificationTime.isAfter(DateTime.now())) {
      await NotificationService.scheduleMonthlyNotification(updatedReminder);
    } else {
      await NotificationService.cancelNotification(updatedReminder.id);
    }
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          updatedReminder.isActive
              ? 'notifications_enable'
              : 'notifications_disable',
        ).tr(),
      ),
    );
  }

  Future<void> _deleteReminder(PaymentReminder reminder) async {
    setState(() {
      _reminders.remove(reminder);
    });

    await _saveReminders();
    await NotificationService.cancelNotification(reminder.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('notifications_delete').tr()),
    );
  }

  void _checkAndCleanPastReminders() {
    final now = DateTime.now();
    final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));
    final remindersToRemove = <PaymentReminder>[];

    for (final reminder in _reminders) {
      if (reminder.notificationTime.isBefore(fiveMinutesAgo)) {
        remindersToRemove.add(reminder);
        NotificationService.cancelNotification(reminder.id);
      }
    }

    if (remindersToRemove.isNotEmpty) {
      setState(() {
        _reminders.removeWhere((r) => remindersToRemove.contains(r));
      });
      _saveReminders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('notifications_removed_expired').tr()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'notifications_add_button',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ).tr(),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'notifications_payment_title'.tr(),
                    hintText: 'notifications_payment_title_hint'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'notifications_amount'.tr(),
                    hintText: 'notifications_amount_hint'.tr(),
                    prefixText: '₹',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: 'notifications_type'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: 'insurance',
                              child: Text('notifications_type_insurance').tr()),
                          DropdownMenuItem(
                              value: 'loan',
                              child: Text('notifications_type_loan').tr()),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_selectedTime),
                          );
                          if (time != null) {
                            setState(() {
                              _selectedTime = DateTime(
                                _selectedDate.year,
                                _selectedDate.month,
                                _selectedDate.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            DateFormat('HH:mm').format(_selectedTime),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('notifications_add_button',
                            style: TextStyle(fontSize: 16))
                        .tr(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: _reminders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'notifications_no_reminders',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ).tr(),
                        const SizedBox(height: 8),
                        Text(
                          'notifications_add_first',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ).tr(),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor: reminder.isActive
                                ? Colors.green.shade100
                                : Colors.grey.shade200,
                            child: Icon(
                              reminder.type == 'insurance'
                                  ? Icons.security
                                  : Icons.account_balance,
                              color: reminder.isActive
                                  ? Colors.green.shade600
                                  : Colors.grey.shade600,
                            ),
                          ),
                          title: Text(
                            reminder.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '₹${reminder.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Due: ${DateFormat('MMM dd').format(reminder.paymentDate)} (Monthly)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: reminder.isActive
                                      ? Colors.green.shade100
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  reminder.isActive
                                      ? 'notifications_active'
                                      : 'notifications_inactive',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: reminder.isActive
                                        ? Colors.green.shade800
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).tr(),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  reminder.isActive
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  color: reminder.isActive
                                      ? Colors.orange.shade600
                                      : Colors.green.shade600,
                                ),
                                onPressed: () => _toggleReminder(reminder),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade600,
                                ),
                                onPressed: () => _deleteReminder(reminder),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _cleanupTimer.cancel();
    super.dispose();
  }
}
