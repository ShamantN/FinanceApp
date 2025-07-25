// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/models/transactions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FinanceTrackerPage extends StatefulWidget {
  const FinanceTrackerPage({super.key});

  @override
  _FinanceTrackerPageState createState() => _FinanceTrackerPageState();
}

class _FinanceTrackerPageState extends State<FinanceTrackerPage> {
  late Box<Transaction> _transactionBox;
  late Box<double> _balanceBox;
  late Box<bool> _flagBox; // New box for boolean flags
  final int _currentIndex = 0;
  double _initialBalance = 0.0;
  bool _isBalanceSet = false;
  List<Transaction> _transactions = [];

  Map<String, IconData> iconMap = {
    'Salary': Icons.trending_up,
    'Freelance': Icons.work,
    'Investment': Icons.show_chart,
    'Groceries': Icons.shopping_cart,
    'Fuel': Icons.local_gas_station,
    'Bills': Icons.flash_on,
    'Entertainment': Icons.movie,
    'Food': Icons.restaurant,
    'Transport': Icons.directions_bus,
    'Other': Icons.more_horiz,
  };

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _transactionBox =
        await HiveFunctions.openBox<Transaction>(expenseBoxWithUid(uid));
    _balanceBox = await HiveFunctions.openBox<double>('balanceBox_$uid');
    _flagBox = await HiveFunctions.openBox<bool>(
        'flagBox_$uid'); // Initialize flag box

    setState(() {
      _transactions = HiveFunctions.readData(_transactionBox);
      _initialBalance =
          _balanceBox.get('initialBalance', defaultValue: 0.0) ?? 0.0;
      _isBalanceSet =
          _flagBox.get('isBalanceSet', defaultValue: false) ?? false;
    });
  }

  double get _totalBalance {
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
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    return _transactions
        .where((t) => t.type == 'Expense' && t.date.isAfter(startOfMonth))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  void _deleteTransaction(int index) async {
    await HiveFunctions.delData(_transactionBox, index);
    setState(() {
      _transactions = HiveFunctions.readData(_transactionBox);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction deleted successfully!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _resetAllData() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Reset All Data?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
              'Are you sure you want to clear all your transactions and reset the balance? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(
              width: 125,
            ),
            ElevatedButton(
              onPressed: () async {
                await _transactionBox.clear();
                await _balanceBox.clear();
                await _flagBox.clear();
                setState(() {
                  _transactions.clear();
                  _initialBalance = 0.0;
                  _isBalanceSet = false;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data reset successfully!'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBalanceSet) {
      return _buildInitialBalanceScreen();
    }

    List<Widget> screens = [
      HomeScreen(
        totalBalance: _totalBalance,
        monthlyExpense: _monthlyExpense,
        transactions: _transactions,
        onDeleteTransaction: _deleteTransaction,
        onEditBalance: _showEditBalanceDialog,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 2,
        title: const Text(
          'Puttannaiah Foundation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: _resetAllData,
          ),
        ],
      ),
      body: screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildInitialBalanceScreen() {
    final balanceController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(height: 12),
              const Text(
                'Welcome to Finance Tracker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your initial balance to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: balanceController,
                decoration: InputDecoration(
                  labelText: 'Initial Balance',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (balanceController.text.isNotEmpty) {
                      setState(() {
                        _initialBalance =
                            double.tryParse(balanceController.text) ?? 0.0;
                        _isBalanceSet = true;
                        _balanceBox.put('initialBalance', _initialBalance);
                        _flagBox.put('isBalanceSet',
                            _isBalanceSet); // Use flagBox for boolean
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditBalanceDialog() {
    final balanceController =
        TextEditingController(text: _initialBalance.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Initial Balance'),
          content: TextField(
            controller: balanceController,
            decoration: InputDecoration(
              labelText: 'Initial Balance',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixText: '₹ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (balanceController.text.isNotEmpty) {
                  setState(() {
                    _initialBalance =
                        double.tryParse(balanceController.text) ?? 0.0;
                    _balanceBox.put('initialBalance', _initialBalance);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Balance updated successfully!'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
              ),
              child:
                  const Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'Income';
    String selectedIconName = 'Salary';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text('Add Transaction', style: TextStyle(fontSize: 18)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: ['Income', 'Expense'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixText: '₹ ',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedIconName,
                      decoration: InputDecoration(
                        labelText: 'Category Icon',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: iconMap.keys.map((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Row(
                            children: [
                              Icon(iconMap[key], size: 16),
                              const SizedBox(width: 6),
                              Text(key, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedIconName = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(fontSize: 14)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (amountController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      double amount =
                          double.tryParse(amountController.text) ?? 0.0;
                      if (amount > 0) {
                        Transaction newTransaction = Transaction(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: descriptionController.text,
                          amount: amount,
                          type: selectedType,
                          iconName: selectedIconName,
                          date: DateTime.now(),
                        );

                        await HiveFunctions.addItem(
                            _transactionBox, newTransaction);
                        setState(() {
                          _transactions =
                              HiveFunctions.readData(_transactionBox);
                        });

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transaction added successfully!'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final double totalBalance;
  final double monthlyExpense;
  final List<Transaction> transactions;
  final Function(int) onDeleteTransaction;
  final VoidCallback onEditBalance;

  const HomeScreen({
    super.key,
    required this.totalBalance,
    required this.monthlyExpense,
    required this.transactions,
    required this.onDeleteTransaction,
    required this.onEditBalance,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, IconData> iconMap = {
      'Salary': Icons.trending_up,
      'Freelance': Icons.work,
      'Investment': Icons.show_chart,
      'Groceries': Icons.shopping_cart,
      'Fuel': Icons.local_gas_station,
      'Bills': Icons.flash_on,
      'Entertainment': Icons.movie,
      'Food': Icons.restaurant,
      'Transport': Icons.directions_bus,
      'Other': Icons.more_horiz,
    };

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onEditBalance,
                  child: _buildBalanceCard(
                    'Total Balance',
                    '₹${totalBalance.toStringAsFixed(0)}',
                    totalBalance >= 0 ? Colors.green : Colors.red,
                    Icons.account_balance_wallet,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBalanceCard(
                  'Monthly Expense',
                  '₹${monthlyExpense.toStringAsFixed(0)}',
                  Colors.red,
                  Icons.trending_down,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '${transactions.length} transactions',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.receipt_long, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Tap the + button to add your first transaction',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...transactions.asMap().entries.map((entry) {
              int index = entry.key;
              Transaction transaction = entry.value;
              return Slidable(
                key: Key(transaction.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => onDeleteTransaction(index),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: _buildTransactionItem(
                  transaction.title,
                  '₹${transaction.amount.toStringAsFixed(0)}',
                  transaction.type,
                  iconMap[transaction.iconName] ?? Icons.more_horiz,
                  transaction.type == 'Income' ? Colors.green : Colors.red,
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
      String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      String title, String amount, String type, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 16,
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
