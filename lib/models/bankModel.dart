import 'package:hive/hive.dart';

part 'bankModel.g.dart';

@HiveType(typeId: 7)
class BankAccountModel {
  @HiveField(0)
  String bankName;

  @HiveField(1)
  String branch;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String holder;

  @HiveField(4)
  String number;

  @HiveField(5)
  String nominee;

  @HiveField(6)
  String accountType;

  @HiveField(7)
  DateTime dob;

  BankAccountModel({
    required this.bankName,
    required this.branch,
    required this.phone,
    required this.holder,
    required this.number,
    required this.nominee,
    required this.accountType,
    required this.dob,
  });
}
