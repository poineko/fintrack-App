// lib/features/receivables/widgets/receivable_tile.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';

class ReceivableTile extends StatelessWidget {
  final Receivable receivable;
  final VoidCallback? onCollect;
  final VoidCallback? onTap;
  final VoidCallback? onWriteOff;

  const ReceivableTile({
    super.key,
    required this.receivable,
    this.onCollect,
    this.onTap,
    this.onWriteOff,
  });

  Color get _statusColor {
    switch (receivable.status) {
      case 'collected':
        return AppColors.settled;
      case 'partiallyCollected':
        return AppColors.transfer;
      case 'writeOff':
        return AppColors.writeOff;
      default:
        return AppColors.active;
    }
  }

  String get _statusLabel {
    switch (receivable.status) {
      case 'collected':
        return 'Lunas';
      case 'partiallyCollected':
        return 'Sebagian';
      case 'writeOff':
        return 'Dihapus';
      default:
        return 'Aktif';
    }
  }

  double get _progressPercent {
    if (receivable.originalAmount <= 0) return 0;
    final collected = receivable.originalAmount - receivable.remainingAmount;
    return (collected / receivable.originalAmount).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isSettled =
        receivable.status == 'collected' || receivable.status == 'writeOff';

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
              // ── Row 1: Avatar + Info + Status ──
              Row(
                children: [
                  // Avatar inisial nama peminjam
                  CircleAvatar(
                    backgroundColor: _statusColor.withValues(alpha: 0.15),
                    child: Text(
                      receivable.borrowerName.substring(0, 1).toUpperCase(),
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
                          receivable.borrowerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (receivable.borrowerContact != null &&
                            receivable.borrowerContact!.isNotEmpty)
                          Text(
                            receivable.borrowerContact!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        Text(
                          'Dipinjam: ${DateHelper.formatDate(receivable.lentAt)}',
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

              // ── Row 2: Purpose ───────────────
              if (receivable.purpose != null &&
                  receivable.purpose!.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        receivable.purpose!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // ── Row 3: Amounts ───────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Piutang',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(receivable.originalAmount),
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
                        'Belum Kembali',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(receivable.remainingAmount),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                              isSettled ? AppColors.settled : AppColors.active,
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
                  valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${(_progressPercent * 100).toStringAsFixed(0)}% sudah kembali',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),

              // ── Target Return Date ───────────
              if (receivable.targetReturnDate != null) ...[
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
                      'Target: ${DateHelper.formatDate(receivable.targetReturnDate!)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],

              // ── Collect Button ───────────────
              if (!isSettled) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Tombol Terima Pembayaran
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: onCollect,
                        icon: const Icon(Icons.attach_money_outlined, size: 16),
                        label: const Text('Terima Bayar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.income,
                          side: const BorderSide(color: AppColors.income),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tombol Write-off
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onWriteOff,
                        icon: const Icon(Icons.money_off_outlined, size: 16),
                        label: const Text('Hapus'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.writeOff,
                          side: const BorderSide(color: AppColors.writeOff),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
