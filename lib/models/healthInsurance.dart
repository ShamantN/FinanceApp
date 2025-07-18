import 'package:hive/hive.dart';

part 'healthInsurance.g.dart';

@HiveType(typeId: 3)
class HealthInsurance {
  @HiveField(0)
  String policyNumber;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  DateTime dob;

  @HiveField(3)
  int age;

  @HiveField(4)
  int height;

  @HiveField(5)
  int weight;

  @HiveField(6)
  String nominee;

  @HiveField(7)
  String mobile;

  @HiveField(8)
  String email;

  @HiveField(9)
  String address;

  @HiveField(10)
  String gender;

  @HiveField(11)
  String insuranceType;

  @HiveField(12)
  String coverageAmount;

  @HiveField(13)
  String medicalCondition;

  HealthInsurance({
    required this.policyNumber,
    required this.fullName,
    required this.dob,
    required this.age,
    required this.height,
    required this.weight,
    required this.nominee,
    required this.mobile,
    required this.email,
    required this.address,
    required this.gender,
    required this.insuranceType,
    required this.coverageAmount,
    required this.medicalCondition,
  });
}
