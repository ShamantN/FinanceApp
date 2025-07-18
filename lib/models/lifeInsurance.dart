import 'package:hive/hive.dart';

part 'lifeInsurance.g.dart';

@HiveType(typeId: 2)
class LifeInsurance {
  @HiveField(0)
  String policyHolderName;

  @HiveField(1)
  String nomineeName;

  @HiveField(2)
  String policyNumber;

  @HiveField(3)
  String insuredCompanyName;

  @HiveField(4)
  String policyType;

  @HiveField(5)
  DateTime issueDate;

  @HiveField(6)
  DateTime maturityDate;

  @HiveField(7)
  double amtInsured;

  @HiveField(8)
  double premiumAmt;

  @HiveField(9)
  String premiumFreq;

  @HiveField(10)
  String remarks;

  LifeInsurance(
      {required this.policyHolderName,
      required this.nomineeName,
      required this.policyNumber,
      required this.insuredCompanyName,
      required this.policyType,
      required this.issueDate,
      required this.maturityDate,
      required this.amtInsured,
      required this.premiumAmt,
      required this.premiumFreq,
      required this.remarks});
}
