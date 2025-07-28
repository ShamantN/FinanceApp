// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';

class BankAccount {
  final TextEditingController bankName = TextEditingController();
  final TextEditingController branch = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController holder = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController nominee = TextEditingController();

  DateTime? dob = DateTime(1900);
  String? accountTypeKey; // Store key instead of translated value
  bool obscureNumber = true;

  void dispose() {
    bankName.dispose();
    branch.dispose();
    phone.dispose();
    holder.dispose();
    number.dispose();
    nominee.dispose();
  }
}

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'kannada': {
      'app_title': 'ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ವಿವರಗಳು',
      'add_new_account': 'ಹೊಸ ಖಾತೆ ಸೇರಿಸಿ',
      'accounts_count': 'ಖಾತೆಗಳು',
      'account': 'ಖಾತೆ',
      'delete_account': 'ಖಾತೆ ಅಳಿಸಿ',
      'bank_name': 'ಬ್ಯಾಂಕ್ ಹೆಸರು',
      'branch': 'ಶಾಖೆ',
      'phone': 'ಫೋನ್',
      'account_holder': 'ಖಾತೆದಾರ',
      'account_number': 'ಖಾತೆ ಸಂಖ್ಯೆ',
      'nominee': 'ನಾಮಿನೀ',
      'account_type': 'ಖಾತೆ ಪ್ರಕಾರ',
      'date_of_birth': 'ಜನ್ಮ ದಿನಾಂಕ',
      'save_changes': 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ',
      'enter_field': 'ನಮೂದಿಸಿ',
      'select_account_type': 'ಖಾತೆ ಪ್ರಕಾರ ಆಯ್ಕೆ ಮಾಡಿ',
      'show': 'ತೋರಿಸು',
      'hide': 'ಮರೆಮಾಡು',
      'all_account_numbers': 'ಎಲ್ಲಾ ಖಾತೆ ಸಂಖ್ಯೆಗಳು',
      'at_least_one_account': 'ಕನಿಷ್ಠ ಒಂದು ಖಾತೆ ಇರಬೇಕು!',
      'accounts_saved': '✅ ಬ್ಯಾಂಕ್ ಖಾತೆಗಳನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ!',
      'language': 'ಭಾಷೆ',
      'savings_account': 'ಉಳಿತಾಯ ಖಾತೆ',
      'current_account': 'ಚಾಲು ಖಾತೆ',
      'fixed_deposit': 'ಸ್ಥಿರ ಠೇವಣಿ ಖಾತೆ',
      'recurring_deposit': 'ಮರುಕಳಿಕೆ ಠೇವಣಿ ಖಾತೆ',
      'demat_account': 'ಡೀಮ್ಯಾಟ್ ಖಾತೆ',
      'nri_account': 'ಅನಿವಾಸಿ ಭಾರತೀಯ ಖಾತೆ',
      'senior_citizen': 'ಹಿರಿಯ ನಾಗರಿಕ ಖಾತೆ',
      'salary_account': 'ಸಂಬಳ ಖಾತೆ',
      'money_market': 'ಮನಿ ಮಾರ್ಕೆಟ್ ಖಾತೆ',
      'retirement_account': 'ವೈಯಕ್ತಿಕ ನಿವೃತ್ತಿ ಖಾತೆ',
      'student_account': 'ವಿದ್ಯಾರ್ಥಿ ಬ್ಯಾಂಕ್ ಖಾತೆ',
    },
    'english': {
      'app_title': 'Your Bank Details',
      'add_new_account': 'Add New Account',
      'accounts_count': 'Accounts',
      'account': 'Account',
      'delete_account': 'Delete Account',
      'bank_name': 'Bank Name',
      'branch': 'Branch',
      'phone': 'Phone',
      'account_holder': 'Account Holder',
      'account_number': 'Account Number',
      'nominee': 'Nominee',
      'account_type': 'Account Type',
      'date_of_birth': 'Date of Birth',
      'save_changes': 'Save Changes',
      'enter_field': 'Enter',
      'select_account_type': 'Select Account Type',
      'show': 'Show',
      'hide': 'Hide',
      'all_account_numbers': 'All Account Numbers',
      'at_least_one_account': 'At least one account is required!',
      'accounts_saved': '✅ Bank accounts saved successfully!',
      'language': 'Language',
      'savings_account': 'Savings Account',
      'current_account': 'Current Account',
      'fixed_deposit': 'Fixed Deposit Account',
      'recurring_deposit': 'Recurring Deposit Account',
      'demat_account': 'DEMAT Account',
      'nri_account': 'NRI Account',
      'senior_citizen': 'Senior Citizen Account',
      'salary_account': 'Salary Account',
      'money_market': 'Money Market Account',
      'retirement_account': 'Individual Retirement Account',
      'student_account': 'Student Bank Account',
    },
  };

  static const List<String> accountTypeKeys = [
    'savings_account',
    'current_account',
    'fixed_deposit',
    'recurring_deposit',
    'demat_account',
    'nri_account',
    'senior_citizen',
    'salary_account',
    'money_market',
    'retirement_account',
    'student_account',
  ];

  static String get(String key, String language) {
    return _localizedValues[language]?[key] ?? key;
  }

  static List<String> getAccountTypes(String language) {
    return accountTypeKeys.map((key) => get(key, language)).toList();
  }

  static Map<String, String> getAccountTypeMap(String language) {
    Map<String, String> map = {};
    for (String key in accountTypeKeys) {
      map[key] = get(key, language);
    }
    return map;
  }
}

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  late final Box _bankBox;
  final List<BankAccount> _accounts = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  String _currentLanguage = 'kannada'; // Default language

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _loadSettings();
    _loadSavedAccounts();
    if (_accounts.isEmpty) {
      _addAccount();
    }
    setState(() {});
  }

  Future<void> _loadSettings() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _bankBox = await HiveFunctions.openBox(bankBoxWithUid(uid));
    _currentLanguage =
        _bankBox.get('language', defaultValue: 'kannada') as String;
  }

  void _saveSettings() {
    _bankBox.put('language', _currentLanguage);
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'kannada' ? 'english' : 'kannada';
    });
    _saveSettings();
  }

  String _getText(String key) {
    return AppLocalizations.get(key, _currentLanguage);
  }

  void _addAccount() {
    setState(() {
      _accounts.add(BankAccount());
    });
  }

  void _removeAccount(int index) {
    if (_accounts.length > 1) {
      setState(() {
        _accounts[index].dispose();
        _accounts.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text(_getText('at_least_one_account'))),
      );
    }
  }

  void _saveBankAccounts() {
    final bankData = _accounts.map((account) {
      return {
        'bankName': account.bankName.text,
        'branch': account.branch.text,
        'phone': account.phone.text,
        'holder': account.holder.text,
        'number': account.number.text,
        'nominee': account.nominee.text,
        'dob': account.dob?.toIso8601String(),
        'accountTypeKey': account.accountTypeKey,
        'obscureNumber': account.obscureNumber,
      };
    }).toList();

    _bankBox.put('accounts', bankData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text(_getText('accounts_saved'))),
    );
  }

  void _loadSavedAccounts() {
    final savedAccounts = _bankBox.get('accounts', defaultValue: []) as List;

    if (savedAccounts.isNotEmpty) {
      for (var data in savedAccounts) {
        final account = BankAccount();
        account.bankName.text = data['bankName'] ?? '';
        account.branch.text = data['branch'] ?? '';
        account.phone.text = data['phone'] ?? '';
        account.holder.text = data['holder'] ?? '';
        account.number.text = data['number'] ?? '';
        account.nominee.text = data['nominee'] ?? '';
        account.obscureNumber = data['obscureNumber'] ?? true;

        account.accountTypeKey = data['accountTypeKey'];

        if (account.accountTypeKey == null && data['accountType'] != null) {
          String oldAccountType = data['accountType'];
          for (String key in AppLocalizations.accountTypeKeys) {
            if (AppLocalizations.get(key, 'kannada') == oldAccountType ||
                AppLocalizations.get(key, 'english') == oldAccountType) {
              account.accountTypeKey = key;
              break;
            }
          }
        }

        final dobString = data['dob'];
        if (dobString != null) {
          account.dob = DateTime.tryParse(dobString) ?? DateTime(1900);
        }
        _accounts.add(account);
      }
    }
  }

  @override
  void dispose() {
    for (var account in _accounts) {
      account.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildLanguageToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${_getText('language')}: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: _toggleLanguage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    _currentLanguage == 'kannada' ? Colors.orange : Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: _currentLanguage == 'kannada' ? 2 : 42,
                    right: _currentLanguage == 'kannada' ? 42 : 2,
                    top: 2,
                    bottom: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _currentLanguage == 'kannada' ? 'ಕ' : 'EN',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _currentLanguage == 'kannada' ? 'ಕನ್ನಡ' : 'English',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      String labelKey, TextEditingController controller, IconData icon,
      {bool obscure = false, bool isAccountNumber = false, int index = 0}) {
    final label = _getText(labelKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isAccountNumber)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    !_accounts[index].obscureNumber
                        ? _getText('show')
                        : _getText('hide'),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _accounts[index].obscureNumber =
                            !_accounts[index].obscureNumber;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: !_accounts[index].obscureNumber
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            left: !_accounts[index].obscureNumber ? 2 : 22,
                            right: !_accounts[index].obscureNumber ? 22 : 2,
                            top: 2,
                            bottom: 2,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                !_accounts[index].obscureNumber
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText:
              isAccountNumber ? _accounts[index].obscureNumber : obscure,
          keyboardType:
              isAccountNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: "${_getText('enter_field')} $label",
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            suffixIcon: isAccountNumber
                ? IconButton(
                    icon: Icon(
                      _accounts[index].obscureNumber
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _accounts[index].obscureNumber =
                            !_accounts[index].obscureNumber;
                      });
                    },
                  )
                : Icon(icon, size: 20, color: Colors.grey.shade600),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountNumberToggle() {
    bool allVisible = _accounts.every((account) => !account.obscureNumber);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${_getText('all_account_numbers')}: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                for (var account in _accounts) {
                  account.obscureNumber = allVisible;
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: allVisible ? Colors.green : Colors.grey.shade400,
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    left: allVisible ? 32 : 2,
                    right: allVisible ? 2 : 32,
                    top: 2,
                    bottom: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        allVisible ? Icons.visibility : Icons.visibility_off,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            allVisible ? _getText('show') : _getText('hide'),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getText('app_title')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_currentLanguage == 'kannada'
                ? Icons.language
                : Icons.translate),
            onPressed: _toggleLanguage,
            tooltip: _getText('language'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildLanguageToggle(),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _addAccount,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(_getText('add_new_account')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  Text(
                    "${_getText('accounts_count')}: ${_accounts.length}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            _buildAccountNumberToggle(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _accounts.length,
                itemBuilder: (context, index) {
                  final account = _accounts[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_getText('account')} ${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                if (_accounts.length > 1)
                                  IconButton(
                                    onPressed: () => _removeAccount(index),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    tooltip: _getText('delete_account'),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildField('bank_name', account.bankName,
                                      Icons.account_balance),
                                  const SizedBox(height: 12),
                                  _buildField('branch', account.branch,
                                      Icons.location_on),
                                  const SizedBox(height: 12),
                                  _buildField(
                                      'phone', account.phone, Icons.phone),
                                  const SizedBox(height: 12),
                                  _buildField('account_holder', account.holder,
                                      Icons.person),
                                  const SizedBox(height: 12),
                                  _buildField('account_number', account.number,
                                      Icons.credit_card,
                                      isAccountNumber: true, index: index),
                                  const SizedBox(height: 12),
                                  _buildField('nominee', account.nominee,
                                      Icons.person_outline),
                                  const SizedBox(height: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getText('account_type'),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: account.accountTypeKey,
                                        items: AppLocalizations.accountTypeKeys
                                            .map((key) => DropdownMenuItem(
                                                  value: key,
                                                  child: Text(
                                                      AppLocalizations.get(key,
                                                          _currentLanguage),
                                                      style: const TextStyle(
                                                          fontSize: 14)),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            account.accountTypeKey = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText:
                                              _getText('select_account_type'),
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.1),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.green, width: 2),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                        ),
                                        isExpanded: true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getText('date_of_birth'),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      DOBInputField(
                                        initialDate:
                                            account.dob ?? DateTime(1900),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                        showLabel: false,
                                        onDateSubmitted: (date) {
                                          setState(() {
                                            account.dob = date;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveBankAccounts,
                  icon: const Icon(Icons.save),
                  label: Text(_getText('save_changes')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
