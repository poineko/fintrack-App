// lib/features/receivables/screens/receivable_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/receivable_provider.dart';
import '../../../providers/wallet_provider.dart';

class ReceivableFormScreen extends ConsumerStatefulWidget {
  const ReceivableFormScreen({super.key});

  @override
  ConsumerState<ReceivableFormScreen> createState() =>
      _ReceivableFormScreenState();
}

class _ReceivableFormScreenState
    extends ConsumerState<ReceivableFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _noteController = TextEditingController();

  Wallet? _sourceWallet;
  DateTime? _targetReturnDate;
  bool _isLoading = false;

  final _uuid = const Uuid();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _targetReturnDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_sourceWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih dompet sumber dana'),
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
          .createReceivable(
            borrowerName: _nameController.text.trim(),
            borrowerContact: _contactController.text.trim().isEmpty
                ? null
                : _contactController.text.trim(),
            amount: amount,
            sourceWalletId: _sourceWallet!.id,
            uuid: _uuid.v4(),
            targetReturnDate: _targetReturnDate,
            purpose: _purposeController.text.trim().isEmpty
                ? null
                : _purposeController.text.trim(),
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Piutang berhasil dicatat'),
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
      appBar: AppBar(title: const Text('Catat Piutang')),
      body: walletsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (wallets) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Info Banner ──────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.income.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.income.withValues(alpha: 0.4),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.income,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Saldo dompet akan berkurang sebesar jumlah piutang dan dicatat sebagai uang yang dipinjamkan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.income,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Nama Peminjam ────────────────
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Peminjam',
                  hintText: 'Contoh: Budi Santoso',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nama peminjam tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Kontak (opsional) ────────────
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP / Kontak (opsional)',
                  hintText: '08xxxxxxxxxx',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              // ── Jumlah ───────────────────────
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Piutang',
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
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Dari Dompet ──────────────────
              _ReceivableWalletDropdown(
                wallets: wallets,
                selected: _sourceWallet,
                onChanged: (w) => setState(() => _sourceWallet = w),
              ),

              const SizedBox(height: 16),

              // ── Tujuan Pinjaman ──────────────
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Tujuan Pinjaman (opsional)',
                  hintText: 'Contoh: Modal usaha',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              // ── Target Kembali ───────────────
              InkWell(
                onTap: _pickTargetDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Target Kembali (opsional)',
                    prefixIcon:
                        Icon(Icons.calendar_today_outlined),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  child: Text(
                    _targetReturnDate == null
                        ? 'Pilih tanggal target kembali'
                        : DateHelper.formatDate(_targetReturnDate!),
                    style: TextStyle(
                      color: _targetReturnDate == null
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
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
                      : const Icon(Icons.save_outlined),
                  label: const Text(
                    'Catat Piutang',
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

class _ReceivableWalletDropdown extends StatelessWidget {
  final List<Wallet> wallets;
  final Wallet? selected;
  final ValueChanged<Wallet?> onChanged;

  const _ReceivableWalletDropdown({
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
        labelText: 'Dana Dari Dompet',
        prefixIcon:
            Icon(Icons.account_balance_wallet_outlined),
      ),
      hint: const Text('Pilih dompet sumber'),
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