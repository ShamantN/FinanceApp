import 'package:hive/hive.dart';

part 'postOffice.g.dart';

@HiveType(typeId: 1)
class PostOffice {
  @HiveField(0)
  String postOfficeName;

  @HiveField(1)
  String postOfficeAddress;

  @HiveField(2)
  String accountNumber;

  @HiveField(3)
  String? schemeType; // selectedScheme

  @HiveField(4)
  String? investmentCategory; // selectedCategory

  @HiveField(5)
  String? riskLevel; // selectedRiskLevel

  @HiveField(6)
  String? tenure; // selectedTenure

  @HiveField(7)
  String nomineeName;

  @HiveField(8)
  double investmentAmount;

  @HiveField(9)
  double currentValue;

  @HiveField(10)
  DateTime openingDate;

  @HiveField(11)
  DateTime? maturityDate;

  @HiveField(12)
  double interestRate;

  @HiveField(13)
  String? remarks;

  @HiveField(14)
  DateTime createdAt; // when the record was made

  PostOffice({
    required this.postOfficeName,
    required this.postOfficeAddress,
    required this.accountNumber,
    this.schemeType,
    this.investmentCategory,
    this.riskLevel,
    this.tenure,
    required this.nomineeName,
    required this.investmentAmount,
    required this.currentValue,
    required this.openingDate,
    this.maturityDate,
    required this.interestRate,
    this.remarks,
    required this.createdAt,
  });
}
