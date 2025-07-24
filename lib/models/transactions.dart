import 'package:hive/hive.dart';

part 'transactions.g.dart';

@HiveType(typeId: 9)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String iconName;

  @HiveField(5)
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.iconName,
    required this.date,
  });
}
