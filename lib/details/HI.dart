import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HealthInsuranceDetails extends StatefulWidget {
  const HealthInsuranceDetails({super.key});

  @override
  State<HealthInsuranceDetails> createState() => _HealthInsuranceDetailsState();
}

class _HealthInsuranceDetailsState extends State<HealthInsuranceDetails> {
  final _formKey = GlobalKey<FormState>();

  final _policyNumberCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _nomineeCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
  ];

  final List<String> insuranceTypes = [
    'Individual Health Insurance',
    'Family Health Insurance',
    'Senior Citizen Health Insurance',
    'Critical Illness Insurance',
    'Hospital Cash Insurance',
    'Personal Accident Insurance',
    'Group Health Insurance',
    'Maternity Health Insurance',
  ];

  final List<String> coverageAmounts = [
    '₹1,00,000',
    '₹2,00,000',
    '₹3,00,000',
    '₹5,00,000',
    '₹10,00,000',
    '₹15,00,000',
    '₹20,00,000',
    '₹25,00,000',
    '₹50,00,000',
    '₹1,00,00,000',
  ];

  final List<String> medicalConditions = [
    'None',
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'Thyroid',
    'Arthritis',
    'Other',
  ];

  String? selectedGender;
  String? selectedInsuranceType;
  String? selectedCoverageAmount;
  String? selectedMedicalCondition;

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
            "Health Insurance Details",
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
                      "Full Name",
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
                      controller: _fullNameCtrl,
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
                          labelText: 'Enter Full Name',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Date of Birth",
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
                      controller: _dobCtrl,
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
                          labelText: 'Enter Date of Birth (DD/MM/YYYY)',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Age",
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
                      controller: _ageCtrl,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.cake, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Age',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        int? age = int.tryParse(value);
                        if (age == null || age < 0 || age > 120) {
                          return 'Please enter valid age';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Gender",
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
                        "Select Gender",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedGender,
                      items: genderOptions
                          .map((gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedGender = newVal.toString();
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
                          return 'Please select gender';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Height (cm)",
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
                      controller: _heightCtrl,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.height, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Height in cm',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter height';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Weight (kg)",
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
                      controller: _weightCtrl,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.monitor_weight,
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
                          labelText: 'Enter Weight in kg',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter weight';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Insurance Type",
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
                        "Select Insurance Type",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedInsuranceType,
                      items: insuranceTypes
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
                          selectedInsuranceType = newVal.toString();
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
                          return 'Please select insurance type';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Coverage Amount",
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
                        "Select Coverage Amount",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedCoverageAmount,
                      items: coverageAmounts
                          .map((amount) => DropdownMenuItem<String>(
                                value: amount,
                                child: Text(
                                  amount,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedCoverageAmount = newVal.toString();
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
                          return 'Please select coverage amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Pre-existing Medical Condition",
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
                        "Select Medical Condition",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightBlue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedMedicalCondition,
                      items: medicalConditions
                          .map((condition) => DropdownMenuItem<String>(
                                value: condition,
                                child: Text(
                                  condition,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          selectedMedicalCondition = newVal.toString();
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
                          return 'Please select medical condition';
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
                      "Mobile Number",
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
                      keyboardType: TextInputType.phone,
                      controller: _mobileCtrl,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.phone, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Mobile Number',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        if (value.length != 10) {
                          return 'Please enter valid 10-digit mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Email Address",
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
                      controller: _emailCtrl,
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
                          labelText: 'Enter Email Address',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email address';
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
                      "Address",
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
                      controller: _addressCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.location_on,
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
                          labelText: 'Enter Complete Address',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
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
                                            'Health Insurance Details Saved Successfully!'),
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
    _policyNumberCtrl.dispose();
    _fullNameCtrl.dispose();
    _dobCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _nomineeCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }
}
