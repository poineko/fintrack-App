// lib/features/internal_debt/screens/repay_kasbon_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/internal_debt_provider.dart';

class RepayKasbonScreen extends ConsumerStatefulWidget {
  final InternalDebt debt;

  const RepayKasbonScreen({super.key, required this.debt});

  @override
  ConsumerState<RepayKasbonScreen> createState() =>
      _RepayKasbonScreenState();
}

class _RepayKasbonScreenState extends ConsumerState<RepayKasbonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  bool _payFull = false;

  final _uuid = const Uuid();

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

    setState(() => _isLoading = true);

    try {
      final amount =
          double.tryParse(_amountController.text.replaceAll('.', '')) ??
              0.0;

      await ref
          .read(internalDebtNotifierProvider.notifier)
          .repayKasbon(
            debtId: widget.debt.id,
            repayAmount: amount,
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
              amount >= widget.debt.remainingAmount
                  ? 'Kasbon lunas! 🎉'
                  : 'Pembayaran kasbon berhasil',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Bayar Kasbon')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Kasbon Info Card ─────────────
            Card(
              color: AppColors.active.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.debt.title,
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
                        const Text(
                          'Total Kasbon',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(
                              widget.debt.originalAmount),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sudah Dibayar',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(
                            widget.debt.originalAmount -
                                widget.debt.remainingAmount,
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
                          'Sisa Kasbon',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(
                              widget.debt.remainingAmount),
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

            // ── Lunasi Semua Toggle ──────────
            SwitchListTile(
              value: _payFull,
              onChanged: _togglePayFull,
              title: const Text('Lunasi Semua Sekarang'),
              subtitle: Text(
                CurrencyFormatter.format(widget.debt.remainingAmount),
                style: const TextStyle(
                  color: AppColors.active,
                  fontWeight: FontWeight.bold,
                ),
              ),
              activeThumbColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 8),

            // ── Jumlah Bayar ─────────────────
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
                if (amount <= 0) return 'Jumlah harus lebih dari 0';
                if (amount > widget.debt.remainingAmount) {
                  return 'Melebihi sisa kasbon (${CurrencyFormatter.format(widget.debt.remainingAmount)})';
                }
                return null;
              },
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
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}