import 'package:flutter/material.dart';

class HealthInsurance extends StatefulWidget {
  const HealthInsurance({super.key});

  @override
  State<HealthInsurance> createState() => _HealthInsuranceState();
}

class _HealthInsuranceState extends State<HealthInsurance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(),
      body: const CircularProgressIndicator(),
    );
  }
}
