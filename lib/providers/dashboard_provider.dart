// lib/providers/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wallet_provider.dart';
import 'transaction_provider.dart';
import 'internal_debt_provider.dart';

class DashboardSummary {
  final double totalBalance;
  final double totalPersonal;
  final double totalShared;
  final double totalEmergency;
  final double totalActiveDebt;
  final double totalExpenseThisMonth;
  final double totalIncomeThisMonth;

  const DashboardSummary({
    required this.totalBalance,
    required this.totalPersonal,
    required this.totalShared,
    required this.totalEmergency,
    required this.totalActiveDebt,
    required this.totalExpenseThisMonth,
    required this.totalIncomeThisMonth,
  });

  double get netWorth => totalBalance - totalActiveDebt;

  /// Rasio tabungan bulan ini — tidak boleh negatif ekstrem
  double get savingsRatio {
    if (totalIncomeThisMonth <= 0) return 0.0;
    final ratio = (totalIncomeThisMonth - totalExpenseThisMonth) /
        totalIncomeThisMonth *
        100;
    // Clamp antara -100% sampai 100%
    return ratio.clamp(-100.0, 100.0);
  }

  /// Apakah bulan ini defisit?
  bool get isDeficit => totalExpenseThisMonth > totalIncomeThisMonth;
}

final dashboardSummaryProvider = StreamProvider<DashboardSummary>((ref) async* {
  // Watch semua stream sekaligus — auto rebuild saat salah satu berubah
  final totalBalance = ref.watch(totalBalanceProvider);
  final totalPersonal = ref.watch(totalPersonalBalanceProvider);
  final totalShared = ref.watch(totalSharedBalanceProvider);
  final totalEmergency = ref.watch(totalEmergencyBalanceProvider);
  final totalActiveDebt = ref.watch(totalActiveDebtProvider);
  final totalExpense = ref.watch(totalExpenseThisMonthProvider);
  final totalIncome = ref.watch(totalIncomeThisMonthProvider);

  // Hanya emit jika semua data sudah tersedia
  final balance = totalBalance.asData?.value;
  final personal = totalPersonal.asData?.value;
  final shared = totalShared.asData?.value;
  final emergency = totalEmergency.asData?.value;
  final debt = totalActiveDebt.asData?.value;
  final expense = totalExpense.asData?.value;
  final income = totalIncome.asData?.value;

  if (balance != null &&
      personal != null &&
      shared != null &&
      emergency != null &&
      debt != null &&
      expense != null &&
      income != null) {
    yield DashboardSummary(
      totalBalance: balance,
      totalPersonal: personal,
      totalShared: shared,
      totalEmergency: emergency,
      totalActiveDebt: debt,
      totalExpenseThisMonth: expense,
      totalIncomeThisMonth: income,
    );
  }
});
