// lib/features/transactions/widgets/transaction_tile.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  Color get _typeColor {
    switch (transaction.type) {
      case 'income':
        return AppColors.income;
      case 'expense':
        return AppColors.expense;
      default:
        return AppColors.transfer;
    }
  }

  IconData get _typeIcon {
    switch (transaction.type) {
      case 'income':
        return Icons.arrow_downward_rounded;
      case 'expense':
        return Icons.arrow_upward_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  String get _typePrefix {
    switch (transaction.type) {
      case 'income':
        return '+';
      case 'expense':
        return '-';
      default:
        return '';
    }
  }

  String get _categoryLabel {
    switch (transaction.category) {
      case 'food':
        return 'Makanan';
      case 'transport':
        return 'Transportasi';
      case 'shopping':
        return 'Belanja';
      case 'bills':
        return 'Tagihan';
      case 'health':
        return 'Kesehatan';
      case 'entertainment':
        return 'Hiburan';
      case 'education':
        return 'Pendidikan';
      case 'salary':
        return 'Gaji';
      case 'freelance':
        return 'Freelance';
      case 'investment':
        return 'Investasi';
      case 'gift':
        return 'Hadiah';
      case 'refund':
        return 'Refund';
      case 'internalDebtBorrow':
        return 'Kasbon';
      case 'internalDebtRepayment':
        return 'Bayar Kasbon';
      case 'receivableGiven':
        return 'Piutang';
      case 'receivableCollection':
        return 'Terima Piutang';
      default:
        return 'Lainnya';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('tx_${transaction.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.expense,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Transaksi'),
            content: const Text('Yakin ingin menghapus transaksi ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.expense,
                ),
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete?.call(),
      child: ListTile(
        onTap: onTap,
        onLongPress: onEdit,
        leading: CircleAvatar(
          backgroundColor: _typeColor.withValues(alpha: 0.1),
          child: Icon(_typeIcon, color: _typeColor, size: 20),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _categoryLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: _typeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              DateHelper.formatRelative(transaction.date),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            // ← TAMBAH hint long press
            const Text(
              '• tahan untuk edit',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: Text(
          '$_typePrefix${CurrencyFormatter.format(transaction.amount)}',
          style: TextStyle(
            color: _typeColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
