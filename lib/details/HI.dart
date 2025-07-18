import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/models/healthInsurance.dart';

class HealthInsuranceDetails extends StatefulWidget {
  const HealthInsuranceDetails({super.key});

  @override
  State<HealthInsuranceDetails> createState() => _HealthInsuranceDetailsState();
}

class _HealthInsuranceDetailsState extends State<HealthInsuranceDetails> {
  final List<HealthInsuranceForm> _forms = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late final Box<HealthInsurance> _hiBox;

  final List<String> genderOptions = [
    'hi_gender_male'.tr(),
    'hi_gender_female'.tr(),
    'hi_gender_other'.tr(),
  ];

  final List<String> insuranceTypes = [
    'hi_insurance_individual'.tr(),
    'hi_insurance_family'.tr(),
    'hi_insurance_senior'.tr(),
    'hi_insurance_critical'.tr(),
    'hi_insurance_hospital_cash'.tr(),
    'hi_insurance_personal_accident'.tr(),
    'hi_insurance_group'.tr(),
    'hi_insurance_maternity'.tr(),
  ];

  final List<String> coverageAmounts = [
    'hi_coverage_100000'.tr(),
    'hi_coverage_200000'.tr(),
    'hi_coverage_300000'.tr(),
    'hi_coverage_500000'.tr(),
    'hi_coverage_1000000'.tr(),
    'hi_coverage_1500000'.tr(),
    'hi_coverage_2000000'.tr(),
    'hi_coverage_2500000'.tr(),
    'hi_coverage_5000000'.tr(),
    'hi_coverage_10000000'.tr(),
  ];

  final List<String> medicalConditions = [
    'hi_condition_none'.tr(),
    'hi_condition_diabetes'.tr(),
    'hi_condition_hypertension'.tr(),
    'hi_condition_heart_disease'.tr(),
    'hi_condition_asthma'.tr(),
    'hi_condition_thyroid'.tr(),
    'hi_condition_arthritis'.tr(),
    'hi_condition_other'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _openAndLoadBox();
  }

  Future<void> _openAndLoadBox() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _hiBox = await HiveFunctions.openBox<HealthInsurance>(hiBoxWithUid(uid));
    for (var key in _hiBox.keys) {
      var data = _hiBox.get(key);
      var form = HealthInsuranceForm(key, genderOptions, insuranceTypes,
          coverageAmounts, medicalConditions);
      form.loadData(data!);
      _forms.add(form);
    }
    setState(() {});
  }

  void _addInsurance() {
    setState(() {
      int newKey = _forms.isEmpty
          ? 0
          : _forms.map((f) => f.key).reduce((a, b) => a > b ? a : b) + 1;
      var newForm = HealthInsuranceForm(newKey, genderOptions, insuranceTypes,
          coverageAmounts, medicalConditions);
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

  void _removeInsurance(int index) {
    setState(() {
      _hiBox.delete(_forms[index].key);
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

  void _saveInsurance(int index) {
    final form = _forms[index];
    if (form.formKey.currentState!.validate()) {
      final data = form.toHealthInsurance();
      _hiBox.put(form.key, data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('hi_save_success'.tr())),
      );
    }
  }

  @override
  void dispose() {
    for (var form in _forms) {
      form.dispose();
    }
    _pageController.dispose();
    _hiBox.close();
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
            'hi_title'.tr(),
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
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: _forms.isEmpty
                  ? Center(
                      child: Text('hi_no_policies'.tr(),
                          style: const TextStyle(color: Colors.white)))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _forms.length,
                      itemBuilder: (context, index) {
                        return _buildInsuranceCard(index);
                      },
                    ),
            ),
            const SizedBox(height: 80),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addInsurance,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(int index) {
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
                    'Policy ${index + 1}',
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
                    onPressed: () => _removeInsurance(index),
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
                            'hi_policy_number'.tr(),
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
                            controller: form.policyNumberCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.policy, color: Colors.white),
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
                              labelText: 'hi_policy_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_policy_number_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_full_name'.tr(),
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
                            controller: form.fullNameCtrl,
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
                              labelText: 'hi_full_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_full_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_dob'.tr(),
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
                            controller: form.dobCtrl,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: form.dob ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  form.dob = picked;
                                  form.dobCtrl.text =
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
                              labelText: 'hi_dob_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_dob_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_age'.tr(),
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
                            controller: form.ageCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.cake, color: Colors.white),
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
                              labelText: 'hi_age_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_age_error'.tr();
                              }
                              int? age = int.tryParse(value);
                              if (age == null || age < 0 || age > 120) {
                                return 'hi_age_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_gender'.tr(),
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
                            value: form.selectedGender,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedGender = newVal;
                              });
                            },
                            items: form.genderOptions.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 115, 149, 169),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.transgender,
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
                              labelText: 'hi_gender_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_gender_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_height'.tr(),
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
                            controller: form.heightCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.height, color: Colors.white),
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
                              labelText: 'hi_height_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_height_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_weight'.tr(),
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
                            controller: form.weightCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.monitor_weight,
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
                              labelText: 'hi_weight_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_weight_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_insurance_type'.tr(),
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
                            value: form.selectedInsuranceType,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedInsuranceType = newVal;
                              });
                            },
                            items: form.insuranceTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 115, 149, 169),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.local_hospital,
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
                              labelText: 'hi_insurance_type_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_insurance_type_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_coverage_amount'.tr(),
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
                            value: form.selectedCoverageAmount,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedCoverageAmount = newVal;
                              });
                            },
                            items: form.coverageAmounts.map((amount) {
                              return DropdownMenuItem<String>(
                                value: amount,
                                child: Text(amount,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 115, 149, 169),
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
                              labelText: 'hi_coverage_amount_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_coverage_amount_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_medical_condition'.tr(),
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
                            value: form.selectedMedicalCondition,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedMedicalCondition = newVal;
                              });
                            },
                            items: form.medicalConditions.map((condition) {
                              return DropdownMenuItem<String>(
                                value: condition,
                                child: Text(condition,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 115, 149, 169),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.medical_services,
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
                              labelText: 'hi_medical_condition_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_medical_condition_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_nominee_name'.tr(),
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
                              suffixIcon: const Icon(Icons.person_outline,
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
                              labelText: 'hi_nominee_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_nominee_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_mobile_number'.tr(),
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
                            controller: form.mobileCtrl,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.phone, color: Colors.white),
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
                              labelText: 'hi_mobile_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_mobile_number_error'.tr();
                              }
                              if (value.length != 10) {
                                return 'hi_mobile_number_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_email'.tr(),
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
                            controller: form.emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.email, color: Colors.white),
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
                              labelText: 'hi_email_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_email_error'.tr();
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'hi_email_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'hi_address'.tr(),
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
                            controller: form.addressCtrl,
                            maxLines: 3,
                            style: const TextStyle(color: Colors.white),
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
                              labelText: 'hi_address_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'hi_address_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                form.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                              ),
                              child: Text('hi_clear_form'.tr()),
                            ),
                            ElevatedButton(
                              onPressed: () => _saveInsurance(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                              ),
                              child: Text('hi_save'.tr()),
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

class HealthInsuranceForm {
  final int key;
  final List<String> genderOptions;
  final List<String> insuranceTypes;
  final List<String> coverageAmounts;
  final List<String> medicalConditions;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController policyNumberCtrl = TextEditingController();
  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController nomineeCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  String? selectedGender;
  String? selectedInsuranceType;
  String? selectedCoverageAmount;
  String? selectedMedicalCondition;
  DateTime? dob;

  HealthInsuranceForm(this.key, this.genderOptions, this.insuranceTypes,
      this.coverageAmounts, this.medicalConditions);

  void loadData(HealthInsurance data) {
    policyNumberCtrl.text = data.policyNumber;
    fullNameCtrl.text = data.fullName;
    dob = data.dob;
    dobCtrl.text = "${data.dob.day}/${data.dob.month}/${data.dob.year}";
    ageCtrl.text = data.age.toString();
    heightCtrl.text = data.height.toString();
    weightCtrl.text = data.weight.toString();
    nomineeCtrl.text = data.nominee;
    mobileCtrl.text = data.mobile;
    emailCtrl.text = data.email;
    addressCtrl.text = data.address;
    selectedGender = genderOptions.contains(data.gender) ? data.gender : null;
    selectedInsuranceType =
        insuranceTypes.contains(data.insuranceType) ? data.insuranceType : null;
    selectedCoverageAmount = coverageAmounts.contains(data.coverageAmount)
        ? data.coverageAmount
        : null;
    selectedMedicalCondition = medicalConditions.contains(data.medicalCondition)
        ? data.medicalCondition
        : null;
  }

  HealthInsurance toHealthInsurance() {
    return HealthInsurance(
      policyNumber: policyNumberCtrl.text,
      fullName: fullNameCtrl.text,
      dob: dob!,
      age: int.parse(ageCtrl.text),
      height: int.parse(heightCtrl.text),
      weight: int.parse(weightCtrl.text),
      nominee: nomineeCtrl.text,
      mobile: mobileCtrl.text,
      email: emailCtrl.text,
      address: addressCtrl.text,
      gender: selectedGender!,
      insuranceType: selectedInsuranceType!,
      coverageAmount: selectedCoverageAmount!,
      medicalCondition: selectedMedicalCondition!,
    );
  }

  void clear() {
    policyNumberCtrl.clear();
    fullNameCtrl.clear();
    dobCtrl.clear();
    ageCtrl.clear();
    heightCtrl.clear();
    weightCtrl.clear();
    nomineeCtrl.clear();
    mobileCtrl.clear();
    emailCtrl.clear();
    addressCtrl.clear();
    selectedGender = null;
    selectedInsuranceType = null;
    selectedCoverageAmount = null;
    selectedMedicalCondition = null;
    dob = null;
  }

  void dispose() {
    policyNumberCtrl.dispose();
    fullNameCtrl.dispose();
    dobCtrl.dispose();
    ageCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    nomineeCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
  }
}
