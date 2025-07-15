import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VehicleInsuranceDetails extends StatefulWidget {
  const VehicleInsuranceDetails({super.key});

  @override
  State<VehicleInsuranceDetails> createState() =>
      _VehicleInsuranceDetailsState();
}

class _VehicleInsuranceDetailsState extends State<VehicleInsuranceDetails> {
  final _formKey = GlobalKey<FormState>();

  final _regCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _engineCtrl = TextEditingController();
  final _chassisCtrl = TextEditingController();
  final _mfgYearCtrl = TextEditingController();
  final _ccCtrl = TextEditingController();
  final _nomineeCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

  final List<String> vehicleTypes = [
    'Two Wheeler',
    'Three Wheeler',
    'Four Wheeler',
    'Commercial Vehicle',
    'Goods Vehicle',
    'Passenger Vehicle',
    'Private Car',
    'Taxi/Cab',
    'Bus',
    'Truck',
    'Tractor',
    'Other',
  ];

  final List<String> insuranceTypes = [
    'Comprehensive Insurance',
    'Third Party Insurance',
    'Own Damage Insurance',
    'Zero Depreciation',
    'Bumper to Bumper',
    'Engine Protection',
    'Return to Invoice',
    'Personal Accident Cover',
  ];

  String? selectedVehicleType;
  String? selectedInsuranceType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 197, 232, 154),
          Color.fromARGB(255, 127, 169, 115),
          Color.fromARGB(255, 100, 209, 103),
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
            "Vehicle Insurance Details",
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
          backgroundColor: Colors.green,
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
                      "Registration Number",
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
                      controller: _regCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.directions_car,
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
                          labelText: 'Enter Vehicle Registration Number',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter registration number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Model Name",
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
                      controller: _modelCtrl,
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.car_repair, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Vehicle Model Name',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter model name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Engine Number",
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
                      controller: _engineCtrl,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.engineering,
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
                          labelText: 'Enter Engine Number',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter engine number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Chassis Number",
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
                      controller: _chassisCtrl,
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.build, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Chassis Number',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter chassis number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Manufacturing Year",
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
                      controller: _mfgYearCtrl,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
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
                          labelText: 'Enter Manufacturing Year',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter manufacturing year';
                        }
                        int? year = int.tryParse(value);
                        if (year == null ||
                            year < 1980 ||
                            year > DateTime.now().year) {
                          return 'Please enter valid year';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 23, bottom: 6, top: 20),
                    child: Text(
                      "Engine Capacity (CC)",
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
                      controller: _ccCtrl,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          suffixIcon:
                              const Icon(Icons.speed, color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.white70, width: 2)),
                          labelText: 'Enter Engine Capacity in CC',
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter engine capacity';
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
                      "Vehicle Type",
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
                        "Select Vehicle Type",
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.lightGreen,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: Colors.white,
                      value: selectedVehicleType,
                      items: vehicleTypes
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
                          selectedVehicleType = newVal.toString();
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
                          return 'Please select vehicle type';
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
                      dropdownColor: Colors.lightGreen,
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
                                        const Color.fromARGB(255, 45, 255, 157)
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle form submission
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Vehicle Insurance Details Saved Successfully!'),
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
    _regCtrl.dispose();
    _modelCtrl.dispose();
    _engineCtrl.dispose();
    _chassisCtrl.dispose();
    _mfgYearCtrl.dispose();
    _ccCtrl.dispose();
    _nomineeCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }
}
