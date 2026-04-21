// lib/features/analytics/widgets/monthly_comparison.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/transaction_provider.dart';
import '../../../repositories/transaction_repository.dart';

class MonthlyComparison extends ConsumerWidget {
  const MonthlyComparison({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thisMonthExpense = ref.watch(totalExpenseThisMonthProvider);
    final lastMonthExpense = ref.watch(totalExpenseLastMonthProvider);
    final last6Async = ref.watch(last6MonthsDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Perbandingan Bulan Ini vs Lalu ──
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'Perbandingan Pengeluaran',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _ComparisonCard(
                  label: 'Bulan Ini',
                  valueAsync: thisMonthExpense,
                  color: AppColors.expense,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ComparisonCard(
                  label: 'Bulan Lalu',
                  valueAsync: lastMonthExpense,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              // Delta Card
              Expanded(
                child: thisMonthExpense.when(
                  loading: () => const _LoadingCard(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (thisMonth) => lastMonthExpense.when(
                    loading: () => const _LoadingCard(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (lastMonth) {
                      if (lastMonth <= 0) {
                        return const _DeltaCard(
                          label: 'Perubahan',
                          delta: 0,
                          isNew: true,
                        );
                      }
                      final delta = ((thisMonth - lastMonth) / lastMonth) * 100;
                      return _DeltaCard(
                        label: 'Perubahan',
                        delta: delta,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Tren 6 Bulan ───────────────────
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'Tren 6 Bulan Terakhir',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        last6Async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (data) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: _TrendChart(data: data),
                  ),
                  const SizedBox(height: 12),
                  // Legend
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendDot(
                        color: AppColors.income,
                        label: 'Pemasukan',
                      ),
                      SizedBox(width: 24),
                      _LegendDot(
                        color: AppColors.expense,
                        label: 'Pengeluaran',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── Ringkasan Keuangan ──────────────
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'Ringkasan Keuangan Bulan Ini',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: thisMonthExpense.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (expense) => ref.watch(totalIncomeThisMonthProvider).when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                      data: (income) {
                        final net = income - expense;
                        final savingsRatio = income > 0
                            ? ((income - expense) / income * 100)
                            : 0.0;

                        return Column(
                          children: [
                            _SummaryRow(
                              label: 'Total Pemasukan',
                              value: CurrencyFormatter.format(income),
                              color: AppColors.income,
                            ),
                            const Divider(height: 16),
                            _SummaryRow(
                              label: 'Total Pengeluaran',
                              value: CurrencyFormatter.format(expense),
                              color: AppColors.expense,
                            ),
                            const Divider(height: 16),
                            _SummaryRow(
                              label: 'Selisih (Net)',
                              value: CurrencyFormatter.format(net),
                              color: net >= 0
                                  ? AppColors.income
                                  : AppColors.expense,
                              isBold: true,
                            ),
                            const Divider(height: 16),
                            _SummaryRow(
                              label: 'Rasio Tabungan',
                              value: '${savingsRatio.toStringAsFixed(1)}%',
                              color: savingsRatio >= 20
                                  ? AppColors.income
                                  : savingsRatio >= 10
                                      ? AppColors.active
                                      : AppColors.expense,
                              isBold: true,
                            ),
                            if (savingsRatio < 20) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.active.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.lightbulb_outline,
                                      color: AppColors.active,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        savingsRatio <= 0
                                            ? 'Pengeluaran melebihi pemasukan bulan ini!'
                                            : 'Idealnya rasio tabungan minimal 20% dari pemasukan.',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.active,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// HELPER WIDGETS
// ─────────────────────────────────────────────

class _ComparisonCard extends StatelessWidget {
  final String label;
  final AsyncValue<double> valueAsync;
  final Color color;

  const _ComparisonCard({
    required this.label,
    required this.valueAsync,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          valueAsync.when(
            loading: () => const SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => const Text('-'),
            data: (v) => Text(
              CurrencyFormatter.compact(v),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeltaCard extends StatelessWidget {
  final String label;
  final double delta;
  final bool isNew;

  const _DeltaCard({
    required this.label,
    required this.delta,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = delta > 0;
    final color = isNew
        ? AppColors.textSecondary
        : isUp
            ? AppColors.expense
            : AppColors.income;
    final icon = isNew
        ? Icons.fiber_new_outlined
        : isUp
            ? Icons.trending_up
            : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                isNew ? 'Baru' : '${delta.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  final List<MonthlyData> data;

  const _TrendChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxY = data.fold<double>(
      0,
      (max, d) {
        if (d.income > max) return d.income;
        if (d.expense > max) return d.expense;
        return max;
      },
    );

    // Hindari division by zero & pastikan maxY > 0
    final chartMaxY = maxY <= 0 ? 100.0 : maxY * 1.3;
    final interval = chartMaxY / 4;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: chartMaxY,
        clipData:
            const FlClipData.all(), // ← Potong garis agar tidak keluar area
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (v) => const FlLine(
            color: AppColors.divider,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) {
                  return const SizedBox.shrink();
                }
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'Mei',
                  'Jun',
                  'Jul',
                  'Agu',
                  'Sep',
                  'Okt',
                  'Nov',
                  'Des',
                ];
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    months[data[idx].month.month - 1],
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: interval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  CurrencyFormatter.compact(value),
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: AppColors.divider),
            left: BorderSide(color: AppColors.divider),
          ),
        ),
        lineBarsData: [
          // Income line
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(
                      e.key.toDouble(),
                      e.value.income < 0 ? 0 : e.value.income,
                    ))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.income,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 3,
                color: AppColors.income,
                strokeWidth: 1.5,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              cutOffY: 0, // ← Potong area di bawah 0
              applyCutOffY: true, // ← Aktifkan cutoff
              color: AppColors.income.withValues(alpha: 0.08),
            ),
          ),
          // Expense line
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(
                      e.key.toDouble(),
                      e.value.expense < 0 ? 0 : e.value.expense,
                    ))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.expense,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 3,
                color: AppColors.expense,
                strokeWidth: 1.5,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              cutOffY: 0, // ← Potong area di bawah 0
              applyCutOffY: true, // ← Aktifkan cutoff
              color: AppColors.expense.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
