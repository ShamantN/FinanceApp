import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:revesion/hiveFunctions.dart';
import 'package:revesion/hive_box_const.dart';
import 'package:revesion/models/vehicle_insurance_model.dart';

class VehicleInsuranceDetails extends StatefulWidget {
  const VehicleInsuranceDetails({super.key});

  @override
  State<VehicleInsuranceDetails> createState() =>
      _VehicleInsuranceDetailsState();
}

class _VehicleInsuranceDetailsState extends State<VehicleInsuranceDetails> {
  final List<VehicleInsuranceForm> _forms = [];
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late final Box<VehicleInsuranceModel> _viBox;

  final List<String> vehicleTypes = [
    'Two Wheeler'.tr(),
    'Three Wheeler'.tr(),
    'Four Wheeler'.tr(),
    'Commercial Vehicle'.tr(),
    'Goods Vehicle'.tr(),
    'Passenger Vehicle'.tr(),
    'Private Car'.tr(),
    'Taxi/Cab'.tr(),
    'Bus'.tr(),
    'Truck'.tr(),
    'Tractor'.tr(),
    'Other'.tr(),
  ];

  final List<String> insuranceTypes = [
    'Comprehensive Insurance'.tr(),
    'Third Party Insurance'.tr(),
    'Own Damage Insurance'.tr(),
    'Zero Depreciation'.tr(),
    'Bumper to Bumper'.tr(),
    'Engine Protection'.tr(),
    'Return to Invoice'.tr(),
    'Personal Accident Cover'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _openAndLoadBox();
  }

  Future<void> _openAndLoadBox() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _viBox =
        await HiveFunctions.openBox<VehicleInsuranceModel>(viBoxWithUid(uid));
    for (var key in _viBox.keys) {
      var data = _viBox.get(key);
      var form = VehicleInsuranceForm(key, vehicleTypes, insuranceTypes);
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
      var newForm = VehicleInsuranceForm(newKey, vehicleTypes, insuranceTypes);
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
      _viBox.delete(_forms[index].key);
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
      final data = form.toVehicleInsurance();
      _viBox.put(form.key, data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text('vi_save_success'.tr())),
      );
    }
  }

  @override
  void dispose() {
    for (var form in _forms) {
      form.dispose();
    }
    _pageController.dispose();
    _viBox.close();
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
            "vi_title".tr(),
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
          backgroundColor: const Color(0xFF1E90FF),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: _forms.isEmpty
                  ? Center(
                      child: Text('vi_no_policies'.tr(),
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
            Color.fromARGB(255, 197, 232, 154),
            Color.fromARGB(255, 127, 169, 115),
            Color.fromARGB(255, 100, 209, 103),
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
                    ('Policy ${index + 1}'),
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
                            "vi_registration_number".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.regCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.directions_car,
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
                              labelText: 'vi_registration_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_registration_number_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_model_name".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.modelCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.car_repair,
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
                              labelText: 'vi_model_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_model_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_engine_number".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.engineCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.engineering,
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
                              labelText: 'vi_engine_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_engine_number_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_chassis_number".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.chassisCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.build, color: Colors.white),
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
                              labelText: 'vi_chassis_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_chassis_number_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_manufacturing_year".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.mfgYearCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
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
                              labelText: 'vi_manufacturing_year_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_manufacturing_year_error'.tr();
                              }
                              int? year = int.tryParse(value);
                              if (year == null ||
                                  year < 1980 ||
                                  year > DateTime.now().year) {
                                return 'vi_manufacturing_year_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_engine_capacity".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: form.ccCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.speed, color: Colors.white),
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
                              labelText: 'vi_engine_capacity_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_engine_capacity_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_nominee_name".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
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
                              labelText: 'vi_nominee_name_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_nominee_name_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_mobile_number".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
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
                              labelText: 'vi_mobile_number_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_mobile_number_error'.tr();
                              }
                              if (value.length != 10) {
                                return 'vi_mobile_number_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_vehicle_type".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: DropdownButtonFormField<String>(
                            value: form.selectedVehicleType,
                            onChanged: (newVal) {
                              setState(() {
                                form.selectedVehicleType = newVal;
                              });
                            },
                            items: form.vehicleTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor:
                                const Color.fromARGB(255, 127, 169, 115),
                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                  Icons.directions_car_filled,
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
                              labelText: 'vi_vehicle_type_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_vehicle_type_error'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, bottom: 6),
                          child: Text(
                            "vi_insurance_type".tr(),
                            style: const TextStyle(
                              fontFamily: "Helvetica",
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
                                const Color.fromARGB(255, 127, 169, 115),
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
                              labelText: 'vi_insurance_type_hint'.tr(),
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'vi_insurance_type_error'.tr();
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
                                foregroundColor: Colors.green,
                              ),
                              child: Text('vi_clear_form'.tr()),
                            ),
                            ElevatedButton(
                              onPressed: () => _saveInsurance(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                              ),
                              child: Text('vi_save'.tr()),
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

class VehicleInsuranceForm {
  final int key;
  final List<String> vehicleTypes;
  final List<String> insuranceTypes;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController regCtrl = TextEditingController();
  final TextEditingController modelCtrl = TextEditingController();
  final TextEditingController engineCtrl = TextEditingController();
  final TextEditingController chassisCtrl = TextEditingController();
  final TextEditingController mfgYearCtrl = TextEditingController();
  final TextEditingController ccCtrl = TextEditingController();
  final TextEditingController nomineeCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();

  String? selectedVehicleType;
  String? selectedInsuranceType;

  VehicleInsuranceForm(this.key, this.vehicleTypes, this.insuranceTypes);

  void loadData(VehicleInsuranceModel data) {
    regCtrl.text = data.registration;
    modelCtrl.text = data.model;
    engineCtrl.text = data.engineNumber;
    chassisCtrl.text = data.chassisNumber;
    mfgYearCtrl.text = data.manufacturingYear;
    ccCtrl.text = data.engineCC;
    nomineeCtrl.text = data.nominee;
    mobileCtrl.text = data.mobile;
    selectedVehicleType =
        vehicleTypes.contains(data.vehicleType) ? data.vehicleType : null;
    selectedInsuranceType =
        insuranceTypes.contains(data.insuranceType) ? data.insuranceType : null;
  }

  VehicleInsuranceModel toVehicleInsurance() {
    return VehicleInsuranceModel(
      registration: regCtrl.text,
      model: modelCtrl.text,
      engineNumber: engineCtrl.text,
      chassisNumber: chassisCtrl.text,
      manufacturingYear: mfgYearCtrl.text,
      engineCC: ccCtrl.text,
      nominee: nomineeCtrl.text,
      mobile: mobileCtrl.text,
      vehicleType: selectedVehicleType!,
      insuranceType: selectedInsuranceType!,
    );
  }

  void clear() {
    regCtrl.clear();
    modelCtrl.clear();
    engineCtrl.clear();
    chassisCtrl.clear();
    mfgYearCtrl.clear();
    ccCtrl.clear();
    nomineeCtrl.clear();
    mobileCtrl.clear();
    selectedVehicleType = null;
    selectedInsuranceType = null;
  }

  void dispose() {
    regCtrl.dispose();
    modelCtrl.dispose();
    engineCtrl.dispose();
    chassisCtrl.dispose();
    mfgYearCtrl.dispose();
    ccCtrl.dispose();
    nomineeCtrl.dispose();
    mobileCtrl.dispose();
  }
}
