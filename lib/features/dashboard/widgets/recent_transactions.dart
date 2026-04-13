// lib/features/dashboard/widgets/recent_transactions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/transaction_provider.dart';

class RecentTransactions extends ConsumerWidget {
  const RecentTransactions({super.key});

  Color _typeColor(String type) {
    switch (type) {
      case 'income':
        return AppColors.income;
      case 'expense':
        return AppColors.expense;
      default:
        return AppColors.transfer;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'income':
        return Icons.arrow_downward_rounded;
      case 'expense':
        return Icons.arrow_upward_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  String _typePrefix(String type) {
    switch (type) {
      case 'income':
        return '+';
      case 'expense':
        return '-';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(allTransactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaksi Terakhir',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/transactions'),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
        ),
        txAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error: $e',
              style: const TextStyle(color: AppColors.expense),
            ),
          ),
          data: (transactions) {
            // Ambil 5 transaksi terbaru saja
            final recent = transactions.take(5).toList();

            if (recent.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppStrings.noData,
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 64,
              ),
              itemBuilder: (context, index) {
                final tx = recent[index];
                return _TransactionTile(
                  transaction: tx,
                  typeColor: _typeColor(tx.type),
                  typeIcon: _typeIcon(tx.type),
                  typePrefix: _typePrefix(tx.type),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final Color typeColor;
  final IconData typeIcon;
  final String typePrefix;

  const _TransactionTile({
    required this.transaction,
    required this.typeColor,
    required this.typeIcon,
    required this.typePrefix,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: typeColor.withValues(alpha: 0.1),
        child: Icon(typeIcon, color: typeColor, size: 20),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        DateHelper.formatRelative(transaction.date),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Text(
        '$typePrefix${CurrencyFormatter.format(transaction.amount)}',
        style: TextStyle(
          color: typeColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
