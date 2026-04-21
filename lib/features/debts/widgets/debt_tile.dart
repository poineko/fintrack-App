// lib/features/debts/widgets/debt_tile.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';

class DebtTile extends StatelessWidget {
  final Debt debt;
  final VoidCallback? onPay;

  const DebtTile({super.key, required this.debt, this.onPay});

  Color get _statusColor {
    switch (debt.status) {
      case 'settled':
        return AppColors.settled;
      case 'partiallyPaid':
        return AppColors.transfer;
      default:
        return AppColors.expense;
    }
  }

  String get _statusLabel {
    switch (debt.status) {
      case 'settled':
        return 'Lunas';
      case 'partiallyPaid':
        return 'Sebagian';
      default:
        return 'Aktif';
    }
  }

  double get _progress {
    if (debt.originalAmount <= 0) return 0;
    return ((debt.originalAmount - debt.remainingAmount) /
            debt.originalAmount)
        .clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isSettled = debt.status == 'settled';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      _statusColor.withValues(alpha: 0.15),
                  child: Text(
                    debt.creditorName
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.creditorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (debt.creditorContact != null)
                        Text(
                          debt.creditorContact!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      Text(
                        'Dipinjam: ${DateHelper.formatDate(debt.borrowedAt)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: _statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            if (debt.purpose != null) ...[
              const SizedBox(height: 8),
              Text(
                debt.purpose!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Amounts ──────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Hutang',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(
                          debt.originalAmount),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Sisa',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(
                          debt.remainingAmount),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSettled
                            ? AppColors.settled
                            : AppColors.expense,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Progress Bar ─────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.divider,
                color: _statusColor,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(_progress * 100).toStringAsFixed(0)}% terlunasi',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),

            if (debt.targetPaymentDate != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Target: ${DateHelper.formatDate(debt.targetPaymentDate!)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],

            // ── Pay Button ───────────────────
            if (!isSettled) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.payments_outlined,
                      size: 16),
                  label: const Text('Bayar Hutang'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.expense,
                    side: const BorderSide(
                        color: AppColors.expense),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}