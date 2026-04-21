// lib/features/internal_debt/screens/kasbon_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/enums.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/internal_debt_provider.dart';
import '../../../providers/wallet_provider.dart';

class KasbonFormScreen extends ConsumerStatefulWidget {
  const KasbonFormScreen({super.key});

  @override
  ConsumerState<KasbonFormScreen> createState() => _KasbonFormScreenState();
}

class _KasbonFormScreenState extends ConsumerState<KasbonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  Wallet? _sourceWallet;
  Wallet? _destinationWallet;
  DateTime? _targetRepaymentDate;
  bool _isLoading = false;

  final _uuid = const Uuid();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
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
      setState(() => _targetRepaymentDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_sourceWallet == null) {
      _showError('Pilih dompet sumber dana kasbon');
      return;
    }
    if (_destinationWallet == null) {
      _showError('Pilih dompet tujuan kasbon');
      return;
    }
    if (_sourceWallet!.id == _destinationWallet!.id) {
      _showError('Dompet sumber dan tujuan tidak boleh sama');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount =
          double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0.0;

      await ref.read(internalDebtNotifierProvider.notifier).createKasbon(
            title: _titleController.text.trim(),
            amount: amount,
            sourceWalletId: _sourceWallet!.id,
            destinationWalletId: _destinationWallet!.id,
            uuid: _uuid.v4(),
            targetRepaymentDate: _targetRepaymentDate,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kasbon berhasil dicatat'),
            backgroundColor: AppColors.income,
          ),
        );
      }
    } catch (e) {
      _showError('$e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.expense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(allWalletsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ambil Kasbon')),
      body: walletsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (wallets) {
          // Sumber kasbon: shared atau emergency
          final sourceWallets = wallets
              .where((w) =>
                  w.category == WalletCategory.shared.name ||
                  w.category == WalletCategory.emergency.name)
              .toList();

          // Tujuan kasbon: personal
          final destWallets = wallets
              .where((w) => w.category == WalletCategory.personal.name)
              .toList();

          if (sourceWallets.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Butuh minimal 1 dompet Tabungan Bersama\natau Dana Darurat sebagai sumber kasbon',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Info Banner ──────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.active.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.active.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.active,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Kasbon akan memindahkan saldo dari dompet sumber ke dompet tujuan dan dicatat sebagai hutang internal.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.active,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Judul Kasbon ─────────────────
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Keperluan Kasbon',
                    hintText: 'Contoh: Beli laptop baru',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Keperluan tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Jumlah ───────────────────────
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Kasbon',
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
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Sumber Dana ──────────────────
                _KasbonWalletDropdown(
                  label: 'Sumber Dana (Diambil Dari)',
                  wallets: sourceWallets,
                  selected: _sourceWallet,
                  onChanged: (w) => setState(() => _sourceWallet = w),
                  emptyHint: 'Tidak ada dompet shared/emergency',
                ),

                const SizedBox(height: 8),

                // Arrow indicator
                const Center(
                  child: Icon(
                    Icons.arrow_downward,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Tujuan Dana ──────────────────
                _KasbonWalletDropdown(
                  label: 'Masuk Ke Dompet',
                  wallets: destWallets,
                  selected: _destinationWallet,
                  onChanged: (w) => setState(() => _destinationWallet = w),
                  emptyHint: 'Tidak ada dompet personal',
                ),

                const SizedBox(height: 16),

                // ── Target Lunas (opsional) ──────
                InkWell(
                  onTap: _pickTargetDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Target Lunas (opsional)',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      _targetRepaymentDate == null
                          ? 'Pilih tanggal target lunas'
                          : DateHelper.formatDate(_targetRepaymentDate!),
                      style: TextStyle(
                        color: _targetRepaymentDate == null
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
                        : const Icon(Icons.swap_horiz),
                    label: const Text(
                      'Ambil Kasbon',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// KASBON WALLET DROPDOWN
// ─────────────────────────────────────────────

class _KasbonWalletDropdown extends StatelessWidget {
  final String label;
  final List<Wallet> wallets;
  final Wallet? selected;
  final ValueChanged<Wallet?> onChanged;
  final String emptyHint;

  const _KasbonWalletDropdown({
    required this.label,
    required this.wallets,
    required this.selected,
    required this.onChanged,
    required this.emptyHint,
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
    if (wallets.isEmpty) {
      return InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          emptyHint,
          style: const TextStyle(color: AppColors.textHint),
        ),
      );
    }

    final currentValue = selected == null
        ? null
        : wallets.where((w) => w.id == selected!.id).firstOrNull;

    return DropdownButtonFormField<Wallet>(
      initialValue: currentValue,
      decoration: InputDecoration(labelText: label),
      hint: Text('Pilih $label'),
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
