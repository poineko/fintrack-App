// lib/features/internal_debt/widgets/kasbon_tile.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';

class KasbonTile extends StatelessWidget {
  final InternalDebt debt;
  final VoidCallback? onRepay;
  final VoidCallback? onTap;

  const KasbonTile({
    super.key,
    required this.debt,
    this.onRepay,
    this.onTap,
  });

  Color get _statusColor {
    switch (debt.status) {
      case 'settled':
        return AppColors.settled;
      case 'partiallyPaid':
        return AppColors.transfer;
      default:
        return AppColors.active;
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

  double get _progressPercent {
    if (debt.originalAmount <= 0) return 0;
    final paid = debt.originalAmount - debt.remainingAmount;
    return (paid / debt.originalAmount).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isSettled = debt.status == 'settled';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: Title + Status Badge ──
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isSettled
                          ? Icons.check_circle_outline
                          : Icons.swap_horiz_rounded,
                      color: _statusColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          debt.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Diambil: ${DateHelper.formatDate(debt.borrowedAt)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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

              const SizedBox(height: 12),

              // ── Row 2: Amounts ───────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Kasbon',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(debt.originalAmount),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
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
                        CurrencyFormatter.format(debt.remainingAmount),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSettled
                              ? AppColors.settled
                              : AppColors.active,
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
                  value: _progressPercent,
                  backgroundColor: AppColors.divider,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_statusColor),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${(_progressPercent * 100).toStringAsFixed(0)}% terlunasi',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),

              // ── Target Date ──────────────────
              if (debt.targetRepaymentDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Target: ${DateHelper.formatDate(debt.targetRepaymentDate!)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],

              // ── Bayar Button ─────────────────
              if (!isSettled) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onRepay,
                    icon: const Icon(Icons.payments_outlined, size: 16),
                    label: const Text('Bayar Kasbon'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}