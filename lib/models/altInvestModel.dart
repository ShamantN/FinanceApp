import 'package:hive/hive.dart';

part 'altInvestModel.g.dart';

@HiveType(typeId: 6)
class AltInvestModel {
  @HiveField(0)
  String nameOfAMC;

  @HiveField(1)
  String registeredEmail;

  @HiveField(2)
  String folio;

  @HiveField(3)
  String nominee;

  @HiveField(4)
  int investmentAmt;

  @HiveField(5)
  int currentValue;

  @HiveField(6)
  DateTime purchaseDate;

  @HiveField(7)
  DateTime maturityDate;

  @HiveField(8)
  int expectedReturn;

  @HiveField(9)
  String remarks;

  @HiveField(10)
  String fundType;

  @HiveField(11)
  String category;

  @HiveField(12)
  String riskLevel;

  AltInvestModel(
      {required this.nameOfAMC,
      required this.registeredEmail,
      required this.folio,
      required this.nominee,
      required this.investmentAmt,
      required this.currentValue,
      required this.purchaseDate,
      required this.maturityDate,
      required this.expectedReturn,
      required this.remarks,
      required this.fundType,
      required this.category,
      required this.riskLevel});
}
