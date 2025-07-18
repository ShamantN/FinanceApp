import 'package:hive/hive.dart';

part 'vehicle_insurance_model.g.dart';

@HiveType(typeId: 5)
class VehicleInsuranceModel extends HiveObject {
  @HiveField(0)
  String registration;

  @HiveField(1)
  String model;

  @HiveField(2)
  String engineNumber;

  @HiveField(3)
  String chassisNumber;

  @HiveField(4)
  String manufacturingYear;

  @HiveField(5)
  String engineCC;

  @HiveField(6)
  String nominee;

  @HiveField(7)
  String mobile;

  @HiveField(8)
  String vehicleType;

  @HiveField(9)
  String insuranceType;

  VehicleInsuranceModel({
    required this.registration,
    required this.model,
    required this.engineNumber,
    required this.chassisNumber,
    required this.manufacturingYear,
    required this.engineCC,
    required this.nominee,
    required this.mobile,
    required this.vehicleType,
    required this.insuranceType,
  });
}
