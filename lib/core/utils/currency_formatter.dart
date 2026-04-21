// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final _compactFormatter = NumberFormat.compactCurrency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 1,
  );

  /// Format lengkap: Rp 1.500.000
  static String format(double amount) {
    return _formatter.format(amount);
  }

  /// Format compact: Rp 1,5 jt
  static String compact(double amount) {
    return _compactFormatter.format(amount);
  }

  /// Format tanpa simbol: 1.500.000
  static String formatNoSymbol(double amount) {
    return NumberFormat('#,###', 'id_ID').format(amount);
  }
}
