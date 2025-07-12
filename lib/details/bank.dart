import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter/material.dart';

/// Holds data for one bank-account card.
class BankAccount {
  final TextEditingController bankName = TextEditingController();
  final TextEditingController branch = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController holder = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController nominee = TextEditingController();

  DateTime? dob;
  String? accountType;
  bool obscureNumber = true; // Added to control account number visibility

  BankAccount() {
    dob = DateTime(1900); // Default DOB
  }

  void dispose() {
    bankName.dispose();
    branch.dispose();
    phone.dispose();
    holder.dispose();
    number.dispose();
  }
}

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final List<BankAccount> _accounts = [BankAccount()];
  final PageController _pageController = PageController(viewportFraction: 0.8);

  final List<String> accountTypes = [
    'Savings Account',
    'Current/Checking Account',
    'Fixed Deposit(FD) Account',
    'Recurring Deposit(RD) Account',
    'DEMAT Account',
    'NRI Account',
    "Senior Citizen's Account",
    'Salary Account',
    'Money Market Account(MMA)',
    'Individual Retirement Account',
    'Student Bank Account',
  ];

  void _addAccount() {
    setState(() {
      _accounts.add(BankAccount());
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _pageController.animateToPage(
        _accounts.length - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _removeAccount(int index) {
    if (_accounts.length > 1) {
      setState(() {
        _accounts[index].dispose();
        _accounts.removeAt(index);
        if (_accounts.isNotEmpty && _pageController.page != null) {
          int newPage = (_pageController.page!.round() >= _accounts.length)
              ? _accounts.length - 1
              : _pageController.page!.round();
          _pageController.animateToPage(
            newPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        }
      });
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

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscure = false,
    bool isAccountNumber = false,
    int index = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Helvetica",
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (isAccountNumber)
              Row(
                children: [
                  const Text(
                    "Show Number",
                    style: TextStyle(
                      fontFamily: "Helvetica",
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  Checkbox(
                    value: !_accounts[index]
                        .obscureNumber, // Invert for "show" logic
                    onChanged: (value) {
                      setState(() {
                        _accounts[index].obscureNumber = !value!;
                      });
                    },
                    activeColor: Colors.green,
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
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            suffixIcon: Icon(icon),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
        backgroundColor: Colors.green,
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text(
          "Your Bank Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 236, 255, 213),
              Color(0xFFB8F2A8),
              Color.fromARGB(255, 100, 209, 103),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: const Color.fromARGB(255, 45, 255, 157)
                                      .withOpacity(0.5),
                                  spreadRadius: 8,
                                  blurRadius: 16,
                                  offset: const Offset(0, 0)),
                            ],
                            borderRadius: BorderRadius.circular(32),
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6A11CB),
                                  Color(0xFF4056D4),
                                  Color(0xFF2575FC),
                                ],
                                stops: [
                                  0.0,
                                  0.5,
                                  1.0
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              onPressed: () {
                                _addAccount();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 10,
                              ),
                              child: const Text(
                                "+ Add New Account",
                                style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _accounts.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, idx) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 60, 20, 20),
                              child: ListView(
                                children: [
                                  _buildField("Bank Name",
                                      _accounts[idx].bankName, Icons.badge),
                                  const SizedBox(height: 16),
                                  _buildField(
                                      "Bank Branch",
                                      _accounts[idx].branch,
                                      Icons.account_balance),
                                  const SizedBox(height: 16),
                                  _buildField(
                                      "Phone Number Associated With Bank",
                                      _accounts[idx].phone,
                                      Icons.phone),
                                  const SizedBox(height: 16),
                                  _buildField("Account Holder",
                                      _accounts[idx].holder, Icons.person),
                                  const SizedBox(height: 16),
                                  _buildField("Account Number",
                                      _accounts[idx].number, Icons.lock,
                                      isAccountNumber: true, index: idx),
                                  const SizedBox(height: 16),
                                  _buildField("Nominee", _accounts[idx].nominee,
                                      Icons.person),
                                  const SizedBox(height: 16),
                                  // Integrated Bank Account Type dropdown
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, bottom: 0, top: 0),
                                    child: Text(
                                      "Bank Account Type",
                                      style: TextStyle(
                                        fontFamily: "Helvetica",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0),
                                    child: DropdownButtonFormField<String>(
                                      hint: const Text(
                                        "Select Your Bank Account Type",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      dropdownColor: Colors.white,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconEnabledColor: Colors.black,
                                      value: _accounts[idx].accountType,
                                      items: accountTypes
                                          .map((type) =>
                                              DropdownMenuItem<String>(
                                                value: type,
                                                child: Text(
                                                  type,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          _accounts[idx].accountType = newVal;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.withOpacity(0.1),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.black, width: 2)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Date of Birth",
                                    style: TextStyle(
                                      fontFamily: "Helvetica",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DOBInputField(
                                    initialDate:
                                        _accounts[idx].dob ?? DateTime(1900),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    dateFormatType: DateFormatType.DDMMYYYY,
                                    showLabel: true,
                                    onDateSubmitted: (date) {
                                      setState(() {
                                        _accounts[idx].dob = date;
                                      });
                                    },
                                    inputDecoration: InputDecoration(
                                      hintText: "DD/MM/YYYY",
                                      filled: true,
                                      fillColor: Colors.grey.withOpacity(0.1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2),
                                      ),
                                      suffixIcon:
                                          const Icon(Icons.calendar_month),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => _removeAccount(idx),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: const Color.fromARGB(255, 45, 255, 157)
                                    .withOpacity(0.5),
                                spreadRadius: 8,
                                blurRadius: 16,
                                offset: const Offset(0, 0)),
                          ],
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                              colors: [
                                Color(0xFF6A11CB),
                                Color(0xFF4056D4),
                                Color(0xFF2575FC),
                              ],
                              stops: [
                                0.0,
                                0.5,
                                1.0
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                            onPressed: () {
                              // Add logic to save changes, including accountType and obscureNumber state
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 10,
                            ),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
