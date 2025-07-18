import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/models/altInvestModel.dart';

class AlternateInvestmentDetails extends StatefulWidget {
  const AlternateInvestmentDetails({super.key});

  @override
  State<AlternateInvestmentDetails> createState() =>
      _AlternateInvestmentDetailsState();
}

class _AlternateInvestmentDetailsState
    extends State<AlternateInvestmentDetails> {
  final List<AlternateInvestmentForm> _forms = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late final Box<AltInvestModel> _aiBox;

  final List<String> fundTypes = [
    'ai_fund_aif'.tr(),
    'ai_fund_mutual'.tr(),
    'ai_fund_pms'.tr(),
    'ai_fund_reit'.tr(),
    'ai_fund_invit'.tr(),
    'ai_fund_commodity'.tr(),
    'ai_fund_hedge'.tr(),
    'ai_fund_private_equity'.tr(),
    'ai_fund_venture'.tr(),
    'ai_fund_angel'.tr(),
    'ai_fund_crypto'.tr(),
    'ai_fund_gold_etf'.tr(),
    'ai_fund_ppf'.tr(),
    'ai_fund_ssy'.tr(),
    'ai_fund_nsc'.tr(),
    'ai_fund_elss'.tr(),
    'ai_fund_ulip'.tr(),
    'ai_fund_other'.tr(),
  ];

  final List<String> amcNames = [
    'ai_amc_hdfc'.tr(),
    'ai_amc_icici'.tr(),
    'ai_amc_sbi'.tr(),
    'ai_amc_axis'.tr(),
    'ai_amc_kotak'.tr(),
    'ai_amc_birla'.tr(),
    'ai_amc_franklin'.tr(),
    'ai_amc_dsp'.tr(),
    'ai_amc_nippon'.tr(),
    'ai_amc_uti'.tr(),
    'ai_amc_tata'.tr(),
    'ai_amc_invesco'.tr(),
    'ai_amc_lnt'.tr(),
    'ai_amc_mirae'.tr(),
    'ai_amc_motilal'.tr(),
    'ai_amc_reliance'.tr(),
    'ai_amc_pgim'.tr(),
    'ai_amc_mahindra'.tr(),
    'ai_amc_canara'.tr(),
    'ai_amc_hsbc'.tr(),
    'ai_amc_gov_india'.tr(),
    'ai_amc_post_office'.tr(),
    'ai_amc_other'.tr(),
  ];

  final List<String> investmentCategories = [
    'ai_category_equity'.tr(),
    'ai_category_debt'.tr(),
    'ai_category_hybrid'.tr(),
    'ai_category_gold'.tr(),
    'ai_category_real_estate'.tr(),
    'ai_category_infrastructure'.tr(),
    'ai_category_alternative'.tr(),
    'ai_category_international'.tr(),
    'ai_category_tax_saving'.tr(),
    'ai_category_government'.tr(),
  ];

  final List<String> riskLevels = [
    'ai_risk_very_low'.tr(),
    'ai_risk_low'.tr(),
    'ai_risk_moderate'.tr(),
    'ai_risk_high'.tr(),
    'ai_risk_very_high'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _openAndLoadBox();
  }

  Future<void> _openAndLoadBox() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ai_no_user'.tr())),
      );
      return;
    }
    final uid = user.uid;
    _aiBox = await HiveFunctions.openBox<AltInvestModel>(aiBoxWithUid(uid));
    for (var key in _aiBox.keys) {
      var data = _aiBox.get(key);
      var form = AlternateInvestmentForm(
          key, fundTypes, amcNames, investmentCategories, riskLevels);
      form.loadData(data!);
      _forms.add(form);
    }
    setState(() {});
  }

  void _addInvestment() {
    setState(() {
      int newKey = _forms.isEmpty
          ? 0
          : _forms.map((f) => f.key).reduce((a, b) => a > b ? a : b) + 1;
      var newForm = AlternateInvestmentForm(
          newKey, fundTypes, amcNames, investmentCategories, riskLevels);
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

  void _removeInvestment(int index) {
    setState(() {
      _aiBox.delete(_forms[index].key);
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

  void _saveInvestment(int index) {
    final form = _forms[index];
    if (form.formKey.currentState!.validate()) {
      final data = form.toAltInvestModel();
      try {
        _aiBox.put(form.key, data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ai_save_success'.tr())),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ai_save_error'.tr(args: [e.toString()]))),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ai_validation_error'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var form in _forms) {
      form.dispose();
    }
    _pageController.dispose();
    _aiBox.close();
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
            'ai_title'.tr(),
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
                      child: Text('ai_no_investments'.tr(),
                          style: const TextStyle(color: Colors.white)))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _forms.length,
                      itemBuilder: (context, index) {
                        return _buildInvestmentCard(index);
                      },
                    ),
            ),
            const SizedBox(height: 80),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addInvestment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildInvestmentCard(int index) {
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
                    'Investment ${index + 1}',
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
                    onPressed: () => _removeInvestment(index),
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
                            'ai_amc_name'.tr(),
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
                            value: form.selectedAMC,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedAMC = newVal;
                              });
                            },
                            items: form.amcNames.map((amc) {
                              return DropdownMenuItem<String>(
                                value: amc,
                                child: Text(amc,
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
                              labelText: 'ai_amc_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_amc_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        if (form.selectedAMC == 'ai_amc_other'.tr()) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 3, bottom: 6),
                            child: Text(
                              'ai_custom_amc_name'.tr(),
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
                              controller: form.nameOfAMCCtrl,
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
                                labelText: 'ai_custom_amc_name_hint'.tr(),
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                              ),
                              validator: (value) {
                                if (form.selectedAMC == 'ai_amc_other'.tr() &&
                                    (value == null || value.isEmpty)) {
                                  return 'ai_custom_amc_name_error'.tr();
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
                            'ai_registered_email'.tr(),
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
                            controller: form.registeredEmailCtrl,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
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
                              labelText: 'ai_registered_email_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_registered_email_error'.tr();
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'ai_registered_email_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_folio_number'.tr(),
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
                            controller: form.folioCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.folder, color: Colors.white),
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
                              labelText: 'ai_folio_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_folio_number_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_fund_type'.tr(),
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
                            value: form.selectedFundType,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedFundType = newVal;
                              });
                            },
                            items: form.fundTypes.map((type) {
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
                              labelText: 'ai_fund_type_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_fund_type_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_investment_category'.tr(),
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
                            value: form.selectedCategory,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedCategory = newVal;
                              });
                            },
                            items: form.investmentCategories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category,
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
                              labelText: 'ai_investment_category_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_investment_category_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_risk_level'.tr(),
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
                            value: form.selectedRiskLevel,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedRiskLevel = newVal;
                              });
                            },
                            items: form.riskLevels.map((risk) {
                              return DropdownMenuItem<String>(
                                value: risk,
                                child: Text(risk,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 115, 149, 169),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.warning,
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
                              labelText: 'ai_risk_level_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_risk_level_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_nominee_name'.tr(),
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
                              labelText: 'ai_nominee_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_nominee_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_investment_amount'.tr(),
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
                            controller: form.investmentAmountCtrl,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                              labelText: 'ai_investment_amount_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_investment_amount_error'.tr();
                              }
                              if (int.tryParse(value) == null) {
                                return 'ai_investment_amount_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_current_value'.tr(),
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
                            controller: form.currentValueCtrl,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.trending_up,
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
                              labelText: 'ai_current_value_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_current_value_error'.tr();
                              }
                              if (int.tryParse(value) == null) {
                                return 'ai_current_value_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_purchase_date'.tr(),
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
                            controller: form.purchaseDateCtrl,
                            style: const TextStyle(color: Colors.white),
                            readOnly: true,
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
                              labelText: 'ai_purchase_date_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  form.purchaseDateCtrl.text =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_purchase_date_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_maturity_date'.tr(),
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
                            style: const TextStyle(color: Colors.white),
                            readOnly: true,
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
                              labelText: 'ai_maturity_date_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() {
                                  form.maturityDateCtrl.text =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_expected_return'.tr(),
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
                            controller: form.expectedReturnCtrl,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.percent,
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
                              labelText: 'ai_expected_return_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ai_expected_return_error'.tr();
                              }
                              if (double.tryParse(value) == null) {
                                return 'ai_expected_return_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            'ai_remarks'.tr(),
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
                            style: const TextStyle(color: Colors.white),
                            maxLines: 3,
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.notes, color: Colors.white),
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
                              labelText: 'ai_remarks_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
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
                              child: Text('ai_clear_form'.tr()),
                            ),
                            ElevatedButton(
                              onPressed: () => _saveInvestment(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                              ),
                              child: Text('ai_save'.tr()),
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

class AlternateInvestmentForm {
  final int key;
  final List<String> fundTypes;
  final List<String> amcNames;
  final List<String> investmentCategories;
  final List<String> riskLevels;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameOfAMCCtrl = TextEditingController();
  final TextEditingController registeredEmailCtrl = TextEditingController();
  final TextEditingController folioCtrl = TextEditingController();
  final TextEditingController nomineeCtrl = TextEditingController();
  final TextEditingController investmentAmountCtrl = TextEditingController();
  final TextEditingController currentValueCtrl = TextEditingController();
  final TextEditingController purchaseDateCtrl = TextEditingController();
  final TextEditingController maturityDateCtrl = TextEditingController();
  final TextEditingController expectedReturnCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  String? selectedFundType;
  String? selectedAMC;
  String? selectedCategory;
  String? selectedRiskLevel;

  AlternateInvestmentForm(this.key, this.fundTypes, this.amcNames,
      this.investmentCategories, this.riskLevels);

  void loadData(AltInvestModel data) {
    nameOfAMCCtrl.text = data.nameOfAMC;
    registeredEmailCtrl.text = data.registeredEmail;
    folioCtrl.text = data.folio;
    nomineeCtrl.text = data.nominee;
    investmentAmountCtrl.text = data.investmentAmt.toString();
    currentValueCtrl.text = data.currentValue.toString();
    purchaseDateCtrl.text =
        "${data.purchaseDate.day}/${data.purchaseDate.month}/${data.purchaseDate.year}";
    maturityDateCtrl.text = data.maturityDate != null
        ? "${data.maturityDate!.day}/${data.maturityDate!.month}/${data.maturityDate!.year}"
        : "";
    expectedReturnCtrl.text = data.expectedReturn.toString();
    remarksCtrl.text = data.remarks;
    selectedFundType = fundTypes.contains(data.fundType) ? data.fundType : null;
    selectedAMC = amcNames.contains(data.nameOfAMC)
        ? data.nameOfAMC
        : 'ai_amc_other'.tr();
    selectedCategory =
        investmentCategories.contains(data.category) ? data.category : null;
    selectedRiskLevel =
        riskLevels.contains(data.riskLevel) ? data.riskLevel : null;
  }

  AltInvestModel toAltInvestModel() {
    final purchaseDateParts = purchaseDateCtrl.text.split('/');
    final maturityDateParts = maturityDateCtrl.text.isNotEmpty
        ? maturityDateCtrl.text.split('/')
        : null;
    return AltInvestModel(
      nameOfAMC: selectedAMC == 'ai_amc_other'.tr()
          ? nameOfAMCCtrl.text
          : selectedAMC!,
      registeredEmail: registeredEmailCtrl.text,
      folio: folioCtrl.text,
      nominee: nomineeCtrl.text,
      investmentAmt: int.parse(investmentAmountCtrl.text),
      currentValue: int.parse(currentValueCtrl.text),
      purchaseDate: DateTime(
        int.parse(purchaseDateParts[2]),
        int.parse(purchaseDateParts[1]),
        int.parse(purchaseDateParts[0]),
      ),
      maturityDate: maturityDateParts != null
          ? DateTime(
              int.parse(maturityDateParts[2]),
              int.parse(maturityDateParts[1]),
              int.parse(maturityDateParts[0]),
            )
          : DateTime.now(),
      expectedReturn: double.parse(expectedReturnCtrl.text).toInt(),
      remarks: remarksCtrl.text.isEmpty ? '' : remarksCtrl.text,
      fundType: selectedFundType!,
      category: selectedCategory!,
      riskLevel: selectedRiskLevel!,
    );
  }

  void clear() {
    nameOfAMCCtrl.clear();
    registeredEmailCtrl.clear();
    folioCtrl.clear();
    nomineeCtrl.clear();
    investmentAmountCtrl.clear();
    currentValueCtrl.clear();
    purchaseDateCtrl.clear();
    maturityDateCtrl.clear();
    expectedReturnCtrl.clear();
    remarksCtrl.clear();
    selectedFundType = null;
    selectedAMC = null;
    selectedCategory = null;
    selectedRiskLevel = null;
  }

  void dispose() {
    nameOfAMCCtrl.dispose();
    registeredEmailCtrl.dispose();
    folioCtrl.dispose();
    nomineeCtrl.dispose();
    investmentAmountCtrl.dispose();
    currentValueCtrl.dispose();
    purchaseDateCtrl.dispose();
    maturityDateCtrl.dispose();
    expectedReturnCtrl.dispose();
    remarksCtrl.dispose();
  }
}
