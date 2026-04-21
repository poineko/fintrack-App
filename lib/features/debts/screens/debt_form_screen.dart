// lib/features/debts/screens/debt_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/debt_provider.dart';
import '../../../providers/wallet_provider.dart';

class DebtFormScreen extends ConsumerStatefulWidget {
  const DebtFormScreen({super.key});

  @override
  ConsumerState<DebtFormScreen> createState() =>
      _DebtFormScreenState();
}

class _DebtFormScreenState extends ConsumerState<DebtFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _noteController = TextEditingController();

  Wallet? _targetWallet;
  DateTime? _targetPaymentDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _targetPaymentDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_targetWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih wallet tujuan dana'),
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

      await ref.read(debtNotifierProvider.notifier).createDebt(
            creditorName: _nameController.text.trim(),
            creditorContact:
                _contactController.text.trim().isEmpty
                    ? null
                    : _contactController.text.trim(),
            amount: amount,
            targetWalletId: _targetWallet!.id,
            purpose: _purposeController.text.trim().isEmpty
                ? null
                : _purposeController.text.trim(),
            targetPaymentDate: _targetPaymentDate,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hutang berhasil dicatat'),
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
      appBar: AppBar(title: const Text('Catat Hutang')),
      body: walletsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (wallets) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.expense
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.expense
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.expense, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dana akan masuk ke wallet yang dipilih. Catat hutang Anda ke orang lain di sini.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.expense,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemberi Hutang',
                  hintText: 'Contoh: Pak Budi',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP (opsional)',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Hutang',
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
                  if ((double.tryParse(v) ?? 0) <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Wallet dropdown
              _buildWalletDropdown(wallets),

              const SizedBox(height: 16),

              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Keperluan (opsional)',
                  hintText: 'Contoh: Modal usaha',
                  prefixIcon:
                      Icon(Icons.description_outlined),
                ),
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Target Bayar (opsional)',
                    prefixIcon:
                        Icon(Icons.calendar_today_outlined),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  child: Text(
                    _targetPaymentDate == null
                        ? 'Pilih tanggal'
                        : DateHelper
                            .formatDate(_targetPaymentDate!),
                    style: TextStyle(
                      color: _targetPaymentDate == null
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.expense,
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
                      : const Icon(Icons.save_outlined),
                  label: const Text(
                    'Catat Hutang',
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

  Widget _buildWalletDropdown(List<Wallet> wallets) {
    final currentValue = _targetWallet == null
        ? null
        : wallets
            .where((w) => w.id == _targetWallet!.id)
            .firstOrNull;

    return DropdownButtonFormField<Wallet>(
      initialValue: currentValue,
      decoration: const InputDecoration(
        labelText: 'Dana Masuk ke Dompet',
        prefixIcon:
            Icon(Icons.account_balance_wallet_outlined),
      ),
      hint: const Text('Pilih dompet'),
      isExpanded: true,
      items: wallets.map((w) {
        return DropdownMenuItem<Wallet>(
          value: w,
          child: Row(
            children: [
              const SizedBox(width: 4),
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
      onChanged: (w) => setState(() => _targetWallet = w),
    );
  }
}