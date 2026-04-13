// lib/features/wallets/screens/wallet_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../transactions/screens/transaction_form_screen.dart';
import '../../transactions/widgets/transaction_tile.dart';

class WalletDetailScreen extends ConsumerWidget {
  final Wallet wallet;

  const WalletDetailScreen({super.key, required this.wallet});

  Color get _categoryColor {
    switch (wallet.category) {
      case 'personal':
        return AppColors.personal;
      case 'shared':
        return AppColors.shared;
      case 'emergency':
        return AppColors.emergency;
      default:
        return AppColors.primary;
    }
  }

  String get _categoryLabel {
    switch (wallet.category) {
      case 'personal':
        return 'Uang Pribadi';
      case 'shared':
        return 'Tabungan Bersama';
      case 'emergency':
        return 'Dana Darurat';
      default:
        return wallet.category;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsByWalletProvider(wallet.id));
    // Watch wallet terbaru agar saldo real-time
    final walletAsync = ref.watch(allWalletsProvider);
    final currentWallet = walletAsync.asData?.value
        .where((w) => w.id == wallet.id)
        .firstOrNull ?? wallet;

    return Scaffold(
      appBar: AppBar(
        title: Text(wallet.name),
        backgroundColor: _categoryColor,
      ),
      body: Column(
        children: [
          // ── Header Saldo ─────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _categoryColor,
                  _categoryColor.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _categoryLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Saldo Saat Ini',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(currentWallet.balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (wallet.description != null &&
                    wallet.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    wallet.description!,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Stats Row ────────────────────
          txAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (txs) {
              final income = txs
                  .where((t) => t.type == 'income')
                  .fold<double>(0, (s, t) => s + t.amount);
              final expense = txs
                  .where((t) => t.type == 'expense')
                  .fold<double>(0, (s, t) => s + t.amount);

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                color: AppColors.surface,
                child: Row(
                  children: [
                    Expanded(
                      child: _StatChip(
                        label: 'Total Masuk',
                        value: CurrencyFormatter.compact(income),
                        color: AppColors.income,
                        icon: Icons.arrow_downward_rounded,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: _StatChip(
                        label: 'Total Keluar',
                        value: CurrencyFormatter.compact(expense),
                        color: AppColors.expense,
                        icon: Icons.arrow_upward_rounded,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: _StatChip(
                        label: 'Transaksi',
                        value: '${txs.length}x',
                        color: AppColors.transfer,
                        icon: Icons.receipt_long_outlined,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 1),

          // ── Transaction List ──────────────
          Expanded(
            child: txAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const TransactionFormScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Catat Transaksi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _categoryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group by date
                final grouped = _groupByDate(transactions);

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final entry = grouped[index];
                    final date = entry.key;
                    final txs = entry.value;
                    final dayTotal =
                        txs.fold<double>(0, (sum, tx) {
                      if (tx.type == 'income') return sum + tx.amount;
                      if (tx.type == 'expense') {
                        return sum - tx.amount;
                      }
                      return sum;
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              16, 12, 16, 4),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateHelper.formatRelative(date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${dayTotal >= 0 ? '+' : ''}${CurrencyFormatter.format(dayTotal)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: dayTotal >= 0
                                      ? AppColors.income
                                      : AppColors.expense,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        ...txs.map((tx) => TransactionTile(
                              transaction: tx,
                              onDelete: () => ref
                                  .read(transactionNotifierProvider
                                      .notifier)
                                  .deleteTransaction(tx.id),
                              onEdit: () =>
                                  Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TransactionFormScreen(
                                          transaction: tx),
                                ),
                              ),
                            )),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const TransactionFormScreen(),
          ),
        ),
        backgroundColor: _categoryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<MapEntry<DateTime, List<Transaction>>> _groupByDate(
    List<Transaction> transactions,
  ) {
    final Map<DateTime, List<Transaction>> map = {};
    for (final tx in transactions) {
      final date =
          DateTime(tx.date.year, tx.date.month, tx.date.day);
      map.putIfAbsent(date, () => []).add(tx);
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return sorted;
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}