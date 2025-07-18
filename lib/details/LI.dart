import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/models/lifeInsurance.dart';

class LifeInsuranceDetails extends StatefulWidget {
  const LifeInsuranceDetails({super.key});

  @override
  State<LifeInsuranceDetails> createState() => _LifeInsuranceDetailsState();
}

class _LifeInsuranceDetailsState extends State<LifeInsuranceDetails> {
  final List<LifeInsuranceForm> _forms = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late final Box<LifeInsurance> _liBox;

  final List<String> insuranceCompanies = [
    'li_company_lic'.tr(),
    'li_company_icici'.tr(),
    'li_company_hdfc'.tr(),
    'li_company_sbi'.tr(),
    'li_company_max'.tr(),
    'li_company_bajaj'.tr(),
    'li_company_kotak'.tr(),
    'li_company_tata'.tr(),
    'li_company_birla'.tr(),
    'li_company_reliance'.tr(),
    'li_company_other'.tr(),
  ];

  final List<String> premiumFrequency = [
    'li_frequency_monthly'.tr(),
    'li_frequency_quarterly'.tr(),
    'li_frequency_half_yearly'.tr(),
    'li_frequency_annually'.tr(),
  ];

  final List<String> policyTypes = [
    'li_policy_term'.tr(),
    'li_policy_whole'.tr(),
    'li_policy_endowment'.tr(),
    'li_policy_ulip'.tr(),
    'li_policy_money_back'.tr(),
    'li_policy_child'.tr(),
    'li_policy_pension'.tr(),
    'li_policy_group'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _openAndLoadBox();
  }

  Future<void> _openAndLoadBox() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _liBox = await HiveFunctions.openBox<LifeInsurance>(liBoxWithUid(uid));
    for (var key in _liBox.keys) {
      var data = _liBox.get(key);
      var form = LifeInsuranceForm(
          key, insuranceCompanies, policyTypes, premiumFrequency);
      form.loadData(data!);
      _forms.add(form);
    }
    setState(() {});
  }

  void _addPolicy() {
    setState(() {
      int newKey = _forms.isEmpty
          ? 0
          : _forms.map((f) => f.key).reduce((a, b) => a > b ? a : b) + 1;
      var newForm = LifeInsuranceForm(
          newKey, insuranceCompanies, policyTypes, premiumFrequency);
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

  void _removePolicy(int index) {
    setState(() {
      _liBox.delete(_forms[index].key);
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

  void _savePolicy(int index) {
    final form = _forms[index];
    if (form.formKey.currentState!.validate()) {
      final data = form.toLifeInsurance();
      _liBox.put(form.key, data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('li_save_success'.tr())),
      );
    }
  }

  @override
  void dispose() {
    for (var form in _forms) {
      form.dispose();
    }
    _pageController.dispose();
    _liBox.close();
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
            'li_title'.tr(),
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
                      child: Text('li_no_policies'.tr(),
                          style: const TextStyle(color: Colors.white)))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _forms.length,
                      itemBuilder: (context, index) {
                        return _buildPolicyCard(index);
                      },
                    ),
            ),
            const SizedBox(height: 80),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addPolicy,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildPolicyCard(int index) {
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
                    onPressed: () => _removePolicy(index),
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
                            'li_policy_holder_name'.tr(),
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
                            controller: form.policyHolderNameCtrl,
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
                              labelText: 'li_policy_holder_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_policy_holder_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_nominee_name'.tr(),
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
                              labelText: 'li_nominee_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_nominee_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_policy_number'.tr(),
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
                              suffixIcon: const Icon(Icons.confirmation_number,
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
                              labelText: 'li_policy_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_policy_number_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_insured_company'.tr(),
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
                            value: form.selectedCompany,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedCompany = newVal;
                              });
                            },
                            items: form.insuranceCompanies.map((company) {
                              return DropdownMenuItem<String>(
                                value: company,
                                child: Text(company,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 115, 149, 169),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.business,
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
                              labelText: 'li_insured_company_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_insured_company_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        if (form.selectedCompany ==
                            'li_company_other'.tr()) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 3, bottom: 6),
                            child: Text(
                              'li_custom_company'.tr(),
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
                              controller: form.insuredCompanyCtrl,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.business,
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
                                labelText: 'li_custom_company_hint'.tr(),
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                              ),
                              validator: (value) {
                                if (form.selectedCompany ==
                                        'li_company_other'.tr() &&
                                    (value == null || value.isEmpty)) {
                                  return 'li_custom_company_error'.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_policy_type'.tr(),
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
                            value: form.selectedPolicyType,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedPolicyType = newVal;
                              });
                            },
                            items: form.policyTypes.map((type) {
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
                              labelText: 'li_policy_type_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_policy_type_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_issue_date'.tr(),
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
                            controller: form.issueDateCtrl,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: form.issueDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  form.issueDate = picked;
                                  form.issueDateCtrl.text =
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
                              labelText: 'li_issue_date_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_issue_date_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_maturity_date'.tr(),
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
                              labelText: 'li_maturity_date_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_maturity_date_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_amount_insured'.tr(),
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
                            controller: form.amountInsuredCtrl,
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
                              labelText: 'li_amount_insured_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_amount_insured_error'.tr();
                              }
                              if (double.tryParse(value) == null) {
                                return 'li_amount_insured_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_premium_amount'.tr(),
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
                            controller: form.premiumCtrl,
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
                              labelText: 'li_premium_amount_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_premium_amount_error'.tr();
                              }
                              if (double.tryParse(value) == null) {
                                return 'li_premium_amount_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_premium_frequency'.tr(),
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
                            value: form.selectedPremiumFrequency,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedPremiumFrequency = newVal;
                              });
                            },
                            items: form.premiumFrequency.map((frequency) {
                              return DropdownMenuItem<String>(
                                value: frequency,
                                child: Text(frequency,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 115, 149, 169),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.repeat, color: Colors.white),
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
                              labelText: 'li_premium_frequency_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'li_premium_frequency_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'li_remarks'.tr(),
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
                              labelText: 'li_remarks_hint'.tr(),
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
                              width: 130,
                              child: ElevatedButton(
                                onPressed: () {
                                  form.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromARGB(255, 115, 149, 169),
                                ),
                                child: Text('li_clear_form'.tr()),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () => _savePolicy(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromARGB(255, 115, 149, 169),
                                ),
                                child: Text('li_save'.tr()),
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

class LifeInsuranceForm {
  final int key;
  final List<String> insuranceCompanies;
  final List<String> policyTypes;
  final List<String> premiumFrequency;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController policyHolderNameCtrl = TextEditingController();
  final TextEditingController nomineeCtrl = TextEditingController();
  final TextEditingController policyNumberCtrl = TextEditingController();
  final TextEditingController insuredCompanyCtrl = TextEditingController();
  final TextEditingController issueDateCtrl = TextEditingController();
  final TextEditingController maturityDateCtrl = TextEditingController();
  final TextEditingController amountInsuredCtrl = TextEditingController();
  final TextEditingController premiumCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  String? selectedCompany;
  String? selectedPremiumFrequency;
  String? selectedPolicyType;
  DateTime? issueDate;
  DateTime? maturityDate;

  LifeInsuranceForm(this.key, this.insuranceCompanies, this.policyTypes,
      this.premiumFrequency);

  void loadData(LifeInsurance data) {
    policyHolderNameCtrl.text = data.policyHolderName;
    nomineeCtrl.text = data.nomineeName;
    policyNumberCtrl.text = data.policyNumber;
    if (insuranceCompanies.contains(data.insuredCompanyName)) {
      selectedCompany = data.insuredCompanyName;
    } else {
      selectedCompany = 'li_company_other'.tr();
      insuredCompanyCtrl.text = data.insuredCompanyName;
    }
    selectedPolicyType =
        policyTypes.contains(data.policyType) ? data.policyType : null;
    selectedPremiumFrequency =
        premiumFrequency.contains(data.premiumFreq) ? data.premiumFreq : null;
    issueDate = data.issueDate;
    issueDateCtrl.text =
        "${data.issueDate.day}/${data.issueDate.month}/${data.issueDate.year}";
    maturityDate = data.maturityDate;
    maturityDateCtrl.text =
        "${data.maturityDate.day}/${data.maturityDate.month}/${data.maturityDate.year}";
    amountInsuredCtrl.text = data.amtInsured.toString();
    premiumCtrl.text = data.premiumAmt.toString();
    remarksCtrl.text = data.remarks;
  }

  LifeInsurance toLifeInsurance() {
    final insuredCompanyName = selectedCompany == 'li_company_other'.tr()
        ? insuredCompanyCtrl.text
        : selectedCompany!;
    return LifeInsurance(
      policyHolderName: policyHolderNameCtrl.text,
      nomineeName: nomineeCtrl.text,
      policyNumber: policyNumberCtrl.text,
      insuredCompanyName: insuredCompanyName,
      policyType: selectedPolicyType!,
      issueDate: issueDate!,
      maturityDate: maturityDate!,
      amtInsured: double.parse(amountInsuredCtrl.text),
      premiumAmt: double.parse(premiumCtrl.text),
      premiumFreq: selectedPremiumFrequency!,
      remarks: remarksCtrl.text,
    );
  }

  void clear() {
    policyHolderNameCtrl.clear();
    nomineeCtrl.clear();
    policyNumberCtrl.clear();
    insuredCompanyCtrl.clear();
    issueDateCtrl.clear();
    maturityDateCtrl.clear();
    amountInsuredCtrl.clear();
    premiumCtrl.clear();
    remarksCtrl.clear();
    selectedCompany = null;
    selectedPolicyType = null;
    selectedPremiumFrequency = null;
    issueDate = null;
    maturityDate = null;
  }

  void dispose() {
    policyHolderNameCtrl.dispose();
    nomineeCtrl.dispose();
    policyNumberCtrl.dispose();
    insuredCompanyCtrl.dispose();
    issueDateCtrl.dispose();
    maturityDateCtrl.dispose();
    amountInsuredCtrl.dispose();
    premiumCtrl.dispose();
    remarksCtrl.dispose();
  }
}
