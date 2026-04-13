// lib/features/analytics/widgets/expense_table.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/transaction_provider.dart';

class ExpenseTable extends ConsumerWidget {
  const ExpenseTable({super.key});

  String _categoryLabel(String category) {
    switch (category) {
      case 'food':
        return '🍔 Makanan';
      case 'transport':
        return '🚗 Transportasi';
      case 'shopping':
        return '🛍️ Belanja';
      case 'bills':
        return '📋 Tagihan';
      case 'health':
        return '🏥 Kesehatan';
      case 'entertainment':
        return '🎮 Hiburan';
      case 'education':
        return '📚 Pendidikan';
      case 'salary':
        return '💼 Gaji';
      case 'freelance':
        return '💻 Freelance';
      case 'investment':
        return '📈 Investasi';
      case 'gift':
        return '🎁 Hadiah';
      case 'refund':
        return '↩️ Refund';
      default:
        return '📦 Lainnya';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(expenseByCategoryProvider);
    final txAsync = ref.watch(allTransactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Pengeluaran Per Kategori ───────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Pengeluaran per Kategori — ${DateHelper.formatMonth(DateTime.now())}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        categoryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (categoryMap) {
            if (categoryMap.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Belum ada pengeluaran bulan ini',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }

            final sorted = categoryMap.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            final total = categoryMap.values.fold<double>(0, (s, v) => s + v);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Header tabel
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Kategori',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Jumlah',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '%',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Rows
                  ...sorted.map((entry) {
                    final pct = total > 0 ? (entry.value / total * 100) : 0.0;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _categoryLabel(entry.key),
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Progress bar per kategori
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: LinearProgressIndicator(
                                        value: pct / 100,
                                        backgroundColor: AppColors.divider,
                                        color: AppColors.expense
                                            .withValues(alpha: 0.7),
                                        minHeight: 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  CurrencyFormatter.compact(entry.value),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.expense,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${pct.toStringAsFixed(1)}%',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 16),
                      ],
                    );
                  }),
                  // Total row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'TOTAL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            CurrencyFormatter.compact(total),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.expense,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            '100%',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // ── Histori Transaksi ──────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Histori Transaksi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              txAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (txs) => Text(
                  '${txs.length} transaksi',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        txAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Belum ada transaksi',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Keterangan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Tanggal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Jumlah',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Rows — max 50
                  ...transactions.take(50).map((tx) {
                    final isIncome = tx.type == 'income';
                    final isExpense = tx.type == 'expense';
                    final color = isIncome
                        ? AppColors.income
                        : isExpense
                            ? AppColors.expense
                            : AppColors.transfer;
                    final prefix = isIncome
                        ? '+'
                        : isExpense
                            ? '-'
                            : '';

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  tx.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  DateHelper.formatShort(tx.date),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '$prefix${CurrencyFormatter.compact(tx.amount)}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 16),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
