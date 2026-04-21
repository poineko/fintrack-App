// lib/features/debts/screens/pay_debt_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/debt_provider.dart';
import '../../../providers/wallet_provider.dart';

class PayDebtScreen extends ConsumerStatefulWidget {
  final Debt debt;

  const PayDebtScreen({super.key, required this.debt});

  @override
  ConsumerState<PayDebtScreen> createState() =>
      _PayDebtScreenState();
}

class _PayDebtScreenState extends ConsumerState<PayDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  Wallet? _fromWallet;
  bool _payFull = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _togglePayFull(bool value) {
    setState(() {
      _payFull = value;
      if (value) {
        _amountController.text =
            widget.debt.remainingAmount.toStringAsFixed(0);
      } else {
        _amountController.clear();
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih wallet sumber pembayaran'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.tryParse(
              _amountController.text.replaceAll('.', '')) ??
          0.0;

      await ref.read(debtNotifierProvider.notifier).payDebt(
            debtId: widget.debt.id,
            payAmount: amount,
            fromWalletId: _fromWallet!.id,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              amount >= widget.debt.remainingAmount
                  ? 'Hutang lunas! 🎉'
                  : 'Pembayaran berhasil',
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
      appBar: AppBar(title: const Text('Bayar Hutang')),
      body: walletsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (wallets) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info card hutang
              Card(
                color: AppColors.expense
                    .withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.debt.creditorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Hutang',
                              style: TextStyle(
                                  color:
                                      AppColors.textSecondary,
                                  fontSize: 13)),
                          Text(
                            CurrencyFormatter.format(
                                widget.debt.originalAmount),
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
                          const Text('Sudah Dibayar',
                              style: TextStyle(
                                  color:
                                      AppColors.textSecondary,
                                  fontSize: 13)),
                          Text(
                            CurrencyFormatter.format(
                              widget.debt.originalAmount -
                                  widget.debt.remainingAmount,
                            ),
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.income),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sisa Hutang',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          Text(
                            CurrencyFormatter.format(
                                widget.debt.remainingAmount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.expense,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                value: _payFull,
                onChanged: _togglePayFull,
                title: const Text('Lunasi Semua Sekarang'),
                subtitle: Text(
                  CurrencyFormatter.format(
                      widget.debt.remainingAmount),
                  style: const TextStyle(
                    color: AppColors.expense,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _amountController,
                enabled: !_payFull,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Bayar',
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
                  if (amount > widget.debt.remainingAmount) {
                    return 'Melebihi sisa hutang';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Wallet dropdown
              DropdownButtonFormField<Wallet>(
                decoration: const InputDecoration(
                  labelText: 'Bayar dari Dompet',
                  prefixIcon: Icon(
                      Icons.account_balance_wallet_outlined),
                ),
                hint: const Text('Pilih dompet'),
                isExpanded: true,
                items: wallets.map((w) {
                  return DropdownMenuItem<Wallet>(
                    value: w,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(w.name,
                              overflow: TextOverflow.ellipsis),
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
                onChanged: (w) =>
                    setState(() => _fromWallet = w),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.check_circle_outline),
                  label: const Text('Bayar Sekarang',
                      style: TextStyle(fontSize: 16)),
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