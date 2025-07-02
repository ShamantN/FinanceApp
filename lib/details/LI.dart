import 'package:flutter/material.dart';

class LifeInsurance extends StatefulWidget {
  const LifeInsurance({super.key});

  @override
  State<LifeInsurance> createState() => _LifeInsuranceState();
}

class _LifeInsuranceState extends State<LifeInsurance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(),
      body: const CircularProgressIndicator(),
    );
  }
}
