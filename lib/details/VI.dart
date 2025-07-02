import 'package:flutter/material.dart';

class VehicleInsurance extends StatefulWidget {
  const VehicleInsurance({super.key});

  @override
  State<VehicleInsurance> createState() => _VehicleInsuranceState();
}

class _VehicleInsuranceState extends State<VehicleInsurance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(),
      body: const CircularProgressIndicator(),
    );
  }
}
