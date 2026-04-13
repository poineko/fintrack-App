// lib/features/receivables/screens/collect_receivable_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/receivable_provider.dart';
import '../../../providers/wallet_provider.dart';

class CollectReceivableScreen extends ConsumerStatefulWidget {
  final Receivable receivable;

  const CollectReceivableScreen({
    super.key,
    required this.receivable,
  });

  @override
  ConsumerState<CollectReceivableScreen> createState() =>
      _CollectReceivableScreenState();
}

class _CollectReceivableScreenState
    extends ConsumerState<CollectReceivableScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  Wallet? _targetWallet;
  bool _isLoading = false;
  bool _collectFull = false;

  final _uuid = const Uuid();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleCollectFull(bool value) {
    setState(() {
      _collectFull = value;
      if (value) {
        _amountController.text =
            widget.receivable.remainingAmount.toStringAsFixed(0);
      } else {
        _amountController.clear();
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_targetWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih dompet tujuan'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount =
          double.tryParse(_amountController.text.replaceAll('.', '')) ??
              0.0;

      await ref
          .read(receivableNotifierProvider.notifier)
          .collectReceivable(
            receivableId: widget.receivable.id,
            collectAmount: amount,
            targetWalletId: _targetWallet!.id,
            uuid: _uuid.v4(),
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              amount >= widget.receivable.remainingAmount
                  ? 'Piutang lunas! 🎉'
                  : 'Pembayaran diterima',
            ),
            backgroundColor: AppColors.income,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(allWalletsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Terima Pembayaran')),
      body: walletsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (wallets) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Receivable Info Card ─────────
              Card(
                color: AppColors.income.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.income
                                .withValues(alpha: 0.15),
                            child: Text(
                              widget.receivable.borrowerName
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.income,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.receivable.borrowerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Piutang',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                                widget.receivable.originalAmount),
                            style:
                                const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sudah Kembali',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                              widget.receivable.originalAmount -
                                  widget.receivable.remainingAmount,
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.income,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sisa Piutang',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                                widget.receivable.remainingAmount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.active,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Terima Semua Toggle ──────────
              SwitchListTile(
                value: _collectFull,
                onChanged: _toggleCollectFull,
                title: const Text('Terima Semua Sekarang'),
                subtitle: Text(
                  CurrencyFormatter.format(
                      widget.receivable.remainingAmount),
                  style: const TextStyle(
                    color: AppColors.income,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 8),

              // ── Jumlah ───────────────────────
              TextFormField(
                controller: _amountController,
                enabled: !_collectFull,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Diterima',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  final amount = double.tryParse(v) ?? 0;
                  if (amount <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
                  if (amount > widget.receivable.remainingAmount) {
                    return 'Melebihi sisa piutang';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Masuk ke Dompet ──────────────
              _CollectWalletDropdown(
                wallets: wallets,
                selected: _targetWallet,
                onChanged: (w) =>
                    setState(() => _targetWallet = w),
              ),

              const SizedBox(height: 16),

              // ── Catatan ──────────────────────
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              // ── Submit ───────────────────────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.income,
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Terima Pembayaran',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WALLET DROPDOWN
// ─────────────────────────────────────────────

class _CollectWalletDropdown extends StatelessWidget {
  final List<Wallet> wallets;
  final Wallet? selected;
  final ValueChanged<Wallet?> onChanged;

  const _CollectWalletDropdown({
    required this.wallets,
    required this.selected,
    required this.onChanged,
  });

  Color _colorFor(String category) {
    switch (category) {
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

  @override
  Widget build(BuildContext context) {
    final currentValue = selected == null
        ? null
        : wallets.where((w) => w.id == selected!.id).firstOrNull;

    return DropdownButtonFormField<Wallet>(
      initialValue: currentValue,
      decoration: const InputDecoration(
        labelText: 'Masuk ke Dompet',
        prefixIcon:
            Icon(Icons.account_balance_wallet_outlined),
      ),
      hint: const Text('Pilih dompet tujuan'),
      isExpanded: true,
      items: wallets.map((w) {
        final color = _colorFor(w.category);
        return DropdownMenuItem<Wallet>(
          value: w,
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  w.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                CurrencyFormatter.format(w.balance),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}