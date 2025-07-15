import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlternateInvestmentDetails extends StatefulWidget {
  const AlternateInvestmentDetails({super.key});

  @override
  State<AlternateInvestmentDetails> createState() =>
      _AlternateInvestmentDetailsState();
}

class _AlternateInvestmentDetailsState
    extends State<AlternateInvestmentDetails> {
  final _formKey = GlobalKey<FormState>();

  final _nameOfAMCCtrl = TextEditingController();
  final _registeredEmailCtrl = TextEditingController();
  final _folioCtrl = TextEditingController();
  final _nomineeCtrl = TextEditingController();
  final _investmentAmountCtrl = TextEditingController();
  final _currentValueCtrl = TextEditingController();
  final _purchaseDateCtrl = TextEditingController();
  final _maturityDateCtrl = TextEditingController();
  final _expectedReturnCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  final List<String> fundTypes = [
    'Alternative Investment Fund (AIF)',
    'Mutual Fund',
    'Portfolio Management Service (PMS)',
    'Real Estate Investment Trust (REIT)',
    'Infrastructure Investment Trust (InvIT)',
    'Commodity Funds',
    'Hedge Funds',
    'Private Equity',
    'Venture Capital',
    'Angel Investing',
    'Cryptocurrency',
    'Gold ETF',
    'PPF (Public Provident Fund)',
    'SSY (Sukanya Samriddhi Yojana)',
    'NSC (National Savings Certificate)',
    'ELSS (Equity Linked Savings Scheme)',
    'ULIPs (Unit Linked Insurance Plans)',
    'Other',
  ];

  final List<String> amcNames = [
    'HDFC Asset Management',
    'ICICI Prudential Asset Management',
    'SBI Funds Management',
    'Axis Asset Management',
    'Kotak Mahindra Asset Management',
    'Birla Sun Life Asset Management',
    'Franklin Templeton Asset Management',
    'DSP Investment Managers',
    'Nippon India Asset Management',
    'UTI Asset Management',
    'Tata Asset Management',
    'Invesco Asset Management',
    'L&T Investment Management',
    'Mirae Asset Global Investments',
    'Motilal Oswal Asset Management',
    'Reliance Asset Management',
    'PGIM India Asset Management',
    'Mahindra Manulife Asset Management',
    'Canara Robeco Asset Management',
    'HSBC Asset Management',
    'Government of India (for PPF/SSY/NSC)',
    'Post Office (for PPF/SSY/NSC)',
    'Other',
  ];

  final List<String> investmentCategories = [
    'Equity Oriented',
    'Debt Oriented',
    'Hybrid/Balanced',
    'Gold/Commodity',
    'Real Estate',
    'Infrastructure',
    'Alternative Assets',
    'International',
    'Tax Saving',
    'Government Schemes',
  ];

  final List<String> riskLevels = [
    'Very Low Risk',
    'Low Risk',
    'Moderate Risk',
    'High Risk',
    'Very High Risk',
  ];

  String? selectedFundType;
  String? selectedAMC;
  String? selectedCategory;
  String? selectedRiskLevel;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameOfAMCCtrl.dispose();
    _registeredEmailCtrl.dispose();
    _folioCtrl.dispose();
    _nomineeCtrl.dispose();
    _investmentAmountCtrl.dispose();
    _currentValueCtrl.dispose();
    _purchaseDateCtrl.dispose();
    _maturityDateCtrl.dispose();
    _expectedReturnCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call or database save
      await Future.delayed(const Duration(seconds: 2));

      // Create data object
      final investmentData = {
        'amc_name': selectedAMC == 'Other' ? _nameOfAMCCtrl.text : selectedAMC,
        'registered_email': _registeredEmailCtrl.text,
        'folio_number': _folioCtrl.text,
        'fund_type': selectedFundType,
        'investment_category': selectedCategory,
        'risk_level': selectedRiskLevel,
        'nominee_name': _nomineeCtrl.text,
        'investment_amount': _investmentAmountCtrl.text,
        'current_value': _currentValueCtrl.text,
        'purchase_date': _purchaseDateCtrl.text,
        'maturity_date':
            _maturityDateCtrl.text.isEmpty ? null : _maturityDateCtrl.text,
        'expected_return': _expectedReturnCtrl.text,
        'remarks': _remarksCtrl.text.isEmpty ? null : _remarksCtrl.text,
        'created_at': DateTime.now().toIso8601String(),
      };

      // TODO: Replace with actual API call or database save
      print('Investment Data: $investmentData');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alternate Investment Details saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Clear form after successful submission
        _clearForm();
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _clearForm() {
    _nameOfAMCCtrl.clear();
    _registeredEmailCtrl.clear();
    _folioCtrl.clear();
    _nomineeCtrl.clear();
    _investmentAmountCtrl.clear();
    _currentValueCtrl.clear();
    _purchaseDateCtrl.clear();
    _maturityDateCtrl.clear();
    _expectedReturnCtrl.clear();
    _remarksCtrl.clear();

    setState(() {
      selectedFundType = null;
      selectedAMC = null;
      selectedCategory = null;
      selectedRiskLevel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 154, 197, 232),
          Color.fromARGB(255, 115, 149, 169),
          Color.fromARGB(255, 103, 149, 209),
        ], stops: [
          0.0,
          0.5,
          1.0,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16))),
          toolbarHeight: 80,
          centerTitle: true,
          title: const Text(
            "Alternate Investment Details",
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 40,
              )),
          backgroundColor: Colors.blue,
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6),
                    child: Text(
                      "Name of AMC",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, right: 20),
                    child: DropdownButtonFormField(
                      hint: const Text(
                        "Select AMC Name",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedAMC,
                      items: amcNames
                          .map((amc) => DropdownMenuItem<String>(
                                value: amc,
                                child: Text(
                                  amc,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedAMC = newVal.toString();
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select AMC name';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Custom AMC name field if "Other" is selected
                  if (selectedAMC == 'Other')
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: _nameOfAMCCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.business, color: Colors.white),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.white70, width: 2)),
                            labelText: 'Enter Custom AMC Name',
                            labelStyle: const TextStyle(color: Colors.white70)),
                        validator: (value) {
                          if (selectedAMC == 'Other' &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter AMC name';
                          }
                          return null;
                        },
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Registered Email ID",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: _registeredEmailCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.email, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Registered Email ID',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter registered email ID';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Folio Number",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: _folioCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.folder, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Folio Number',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter folio number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Type of Fund",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, right: 20),
                    child: DropdownButtonFormField(
                      hint: const Text(
                        "Select Fund Type",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedFundType,
                      items: fundTypes
                          .map((type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(
                                  type,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedFundType = newVal.toString();
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select fund type';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Investment Category",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, right: 20),
                    child: DropdownButtonFormField(
                      hint: const Text(
                        "Select Investment Category",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedCategory,
                      items: investmentCategories
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(
                                  category,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedCategory = newVal.toString();
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select investment category';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Risk Level",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23, right: 20),
                    child: DropdownButtonFormField(
                      hint: const Text(
                        "Select Risk Level",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedRiskLevel,
                      items: riskLevels
                          .map((risk) => DropdownMenuItem<String>(
                                value: risk,
                                child: Text(
                                  risk,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedRiskLevel = newVal.toString();
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select risk level';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Nominee Name",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      controller: _nomineeCtrl,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.person_outline,
                              color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Nominee Name',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter nominee name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Investment Amount",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      controller: _investmentAmountCtrl,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.currency_rupee,
                              color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Investment Amount (₹)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter investment amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Current Value",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      controller: _currentValueCtrl,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.trending_up,
                              color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Current Value (₹)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter current value';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid value';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Purchase Date",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      controller: _purchaseDateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_today,
                              color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Select Purchase Date',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _purchaseDateCtrl.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select purchase date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Maturity Date (if applicable)",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      controller: _maturityDateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.event, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Select Maturity Date (Optional)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(days: 365)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _maturityDateCtrl.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Expected Return (%)",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _expectedReturnCtrl,
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.percent, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Expected Return (%)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expected return';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid percentage';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Remarks (Optional)",
                      style: TextStyle(
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      controller: _remarksCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.notes, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Remarks (if any)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitForm,
                      icon: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save),
                      label:
                          Text(_isSubmitting ? 'Saving...' : 'Save Investment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
