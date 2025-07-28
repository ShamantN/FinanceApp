import 'package:intl/intl.dart';

class NumberFormatter {
  static final NumberFormat indianFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String formatIndianCurrency(double amount) {
    return indianFormat.format(amount);
  }
}
