// lib/core/utils/date_helper.dart
import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static final _dateFormatter = DateFormat('dd MMM yyyy', 'id_ID');
  static final _dateTimeFormatter =
      DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
  static final _monthFormatter = DateFormat('MMMM yyyy', 'id_ID');
  static final _shortFormatter = DateFormat('dd/MM/yyyy');

  /// 25 Jan 2025
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// 25 Jan 2025, 14:30
  static String formatDateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  /// Januari 2025
  static String formatMonth(DateTime date) {
    return _monthFormatter.format(date);
  }

  /// 25/01/2025
  static String formatShort(DateTime date) {
    return _shortFormatter.format(date);
  }

  /// Hari ini / Kemarin / dd MMM yyyy
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Kemarin';
    return formatDate(date);
  }

  /// Awal bulan ini
  static DateTime startOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month, 1);
  }

  /// Akhir bulan ini
  static DateTime endOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month + 1, 0, 23, 59, 59);
  }
}