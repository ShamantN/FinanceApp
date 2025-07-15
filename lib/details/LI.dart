import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LifeInsuranceDetails extends StatefulWidget {
  const LifeInsuranceDetails({super.key});

  @override
  State<LifeInsuranceDetails> createState() => _LifeInsuranceDetailsState();
}

class _LifeInsuranceDetailsState extends State<LifeInsuranceDetails> {
  final _formKey = GlobalKey<FormState>();

  final _policyHolderNameCtrl = TextEditingController();
  final _nomineeCtrl = TextEditingController();
  final _policyNumberCtrl = TextEditingController();
  final _insuredCompanyCtrl = TextEditingController();
  final _issueDateCtrl = TextEditingController();
  final _maturityDateCtrl = TextEditingController();
  final _amountInsuredCtrl = TextEditingController();
  final _premiumCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  final List<String> insuranceCompanies = [
    'LIC of India',
    'ICICI Prudential Life Insurance',
    'HDFC Life Insurance',
    'SBI Life Insurance',
    'Max Life Insurance',
    'Bajaj Allianz Life Insurance',
    'Kotak Mahindra Life Insurance',
    'Tata AIA Life Insurance',
    'Birla Sun Life Insurance',
    'Reliance Nippon Life Insurance',
    'Other',
  ];

  final List<String> premiumFrequency = [
    'Monthly',
    'Quarterly',
    'Half-yearly',
    'Annually',
  ];

  final List<String> policyTypes = [
    'Term Life Insurance',
    'Whole Life Insurance',
    'Endowment Policy',
    'Unit Linked Insurance Plan (ULIP)',
    'Money Back Policy',
    'Child Insurance Plan',
    'Pension Plan',
    'Group Life Insurance',
  ];

  String? selectedCompany;
  String? selectedPremiumFrequency;
  String? selectedPolicyType;

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
            "Life Insurance Details",
            style: TextStyle(
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                fontSize: 32,
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
                      "Policy Holder Name",
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
                      controller: _policyHolderNameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.person, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Policy Holder Name',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter policy holder name';
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
                      "Policy Number",
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
                      controller: _policyNumberCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.policy, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Policy Number',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter policy number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Insured Company Name",
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
                        "Select Insurance Company",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedCompany,
                      items: insuranceCompanies
                          .map((company) => DropdownMenuItem<String>(
                                value: company,
                                child: Text(
                                  company,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedCompany = newVal.toString();
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
                          return 'Please select insurance company';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Custom company name field if "Other" is selected
                  if (selectedCompany == 'Other')
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: _insuredCompanyCtrl,
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
                            labelText: 'Enter Company Name',
                            labelStyle: const TextStyle(color: Colors.white70)),
                        validator: (value) {
                          if (selectedCompany == 'Other' &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Policy Type",
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
                        "Select Policy Type",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedPolicyType,
                      items: policyTypes
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
                          selectedPolicyType = newVal.toString();
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
                          return 'Please select policy type';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Issue Date",
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
                      controller: _issueDateCtrl,
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
                          labelText: 'Select Issue Date',
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
                            _issueDateCtrl.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select issue date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Maturity Date",
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
                          labelText: 'Select Maturity Date',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select maturity date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Amount Insured",
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
                      controller: _amountInsuredCtrl,
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
                          labelText: 'Enter Amount Insured (₹)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount insured';
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
                      "Premium Amount",
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
                      controller: _premiumCtrl,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.payment, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Premium Amount (₹)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter premium amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter valid premium amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Premium Frequency",
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
                        "Select Premium Frequency",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedPremiumFrequency,
                      items: premiumFrequency
                          .map((frequency) => DropdownMenuItem<String>(
                                value: frequency,
                                child: Text(
                                  frequency,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedPremiumFrequency = newVal.toString();
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
                          return 'Please select premium frequency';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Remarks",
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
                              const Icon(Icons.note_alt, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Remarks (Optional)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 45, 157, 255)
                                            .withOpacity(0.5),
                                    spreadRadius: 8,
                                    blurRadius: 16,
                                    offset: const Offset(0, 0)),
                              ],
                              borderRadius: BorderRadius.circular(32),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF11CB6A),
                                    Color(0xFF40D456),
                                    Color(0xFF25FC75),
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle form submission
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Life Insurance Details Saved Successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  elevation: 10,
                                ),
                                child: const Text(
                                  "Save Insurance Details",
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _policyHolderNameCtrl.dispose();
    _nomineeCtrl.dispose();
    _policyNumberCtrl.dispose();
    _insuredCompanyCtrl.dispose();
    _issueDateCtrl.dispose();
    _maturityDateCtrl.dispose();
    _amountInsuredCtrl.dispose();
    _premiumCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }
}
