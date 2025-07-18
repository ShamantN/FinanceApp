import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:revesion/bottomNavBar/navigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Payment Model
class PaymentReminder {
  final String id;
  final String title;
  final double amount;
  final DateTime paymentDate;
  final String type; // 'insurance' or 'loan'
  final bool isActive;

  PaymentReminder({
    required this.id,
    required this.title,
    required this.amount,
    required this.paymentDate,
    required this.type,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
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
      type: json['type'],
      isActive: json['isActive'] ?? true,
    );
  }

  PaymentReminder copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? paymentDate,
    String? type,
    bool? isActive,
  }) {
    return PaymentReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
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
    tz.initializeTimeZones(); // Initialize time zones
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

    // Calculate next payment date
    DateTime nextPayment = reminder.paymentDate;
    final now = DateTime.now();
    if (nextPayment.isBefore(now)) {
      nextPayment = DateTime(now.year, now.month + 1, reminder.paymentDate.day);
    }

    await _notifications.zonedSchedule(
      reminder.id.hashCode,
      '${reminder.type.toUpperCase()} Payment Due',
      'Don\'t forget to pay ${reminder.title} - \$${reminder.amount.toStringAsFixed(2)}',
      _convertToTZDateTime(nextPayment),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  static tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final location = tz.local;
    return tz.TZDateTime.from(dateTime, location);
  }

  static Future<void> cancelNotification(String reminderId) async {
    await _notifications.cancel(reminderId.hashCode);
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
  String _selectedType = 'insurance';

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadReminders();
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
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newReminder = PaymentReminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      paymentDate: _selectedDate,
      type: _selectedType,
    );

    setState(() {
      _reminders.add(newReminder);
    });

    await _saveReminders();
    await NotificationService.scheduleMonthlyNotification(newReminder);

    _titleController.clear();
    _amountController.clear();
    _selectedDate = DateTime.now();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment reminder added successfully!')),
    );
  }

  Future<void> _toggleReminder(PaymentReminder reminder) async {
    final updatedReminder = reminder.copyWith(isActive: !reminder.isActive);

    setState(() {
      final index = _reminders.indexOf(reminder);
      _reminders[index] = updatedReminder;
    });

    await _saveReminders();

    if (updatedReminder.isActive) {
      await NotificationService.scheduleMonthlyNotification(updatedReminder);
    } else {
      await NotificationService.cancelNotification(updatedReminder.id);
    }
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updatedReminder.isActive
              ? 'Notifications enabled'
              : 'Notifications disabled',
        ),
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
      const SnackBar(content: Text('Payment reminder deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(navIndex: 2),
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
        elevation: 10,
        title: const Text(
          'Payment Reminders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Add new reminder section
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Payment Reminder',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Payment Title',
                    hintText: 'e.g., Car Insurance, Home Loan',
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
                    labelText: 'Amount',
                    hintText: 'Enter amount to pay',
                    prefixText: '\$',
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
                          labelText: 'Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'insurance', child: Text('Insurance')),
                          DropdownMenuItem(value: 'loan', child: Text('Loan')),
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
                    child: const Text('Add Reminder',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),

          // Reminders list
          Expanded(
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
                          'No payment reminders yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first reminder above',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
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
                                '\$${reminder.amount.toStringAsFixed(2)}',
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
                                  reminder.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: reminder.isActive
                                        ? Colors.green.shade800
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
    super.dispose();
  }
}
