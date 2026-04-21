// lib/features/wallets/screens/wallet_form_screen.dart
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/enums.dart';
import '../../../core/database/app_database.dart';
import '../../../providers/wallet_provider.dart';

class WalletFormScreen extends ConsumerStatefulWidget {
  /// Jika null = mode tambah, jika ada isi = mode edit
  final Wallet? wallet;

  const WalletFormScreen({super.key, this.wallet});

  @override
  ConsumerState<WalletFormScreen> createState() => _WalletFormScreenState();
}

class _WalletFormScreenState extends ConsumerState<WalletFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _descriptionController = TextEditingController();

  WalletCategory _selectedCategory = WalletCategory.personal;
  bool _isLoading = false;

  bool get _isEditMode => widget.wallet != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final w = widget.wallet!;
      _nameController.text = w.name;
      _balanceController.text = w.balance.toStringAsFixed(0);
      _descriptionController.text = w.description ?? '';
      _selectedCategory = WalletCategory.values.firstWhere(
        (c) => c.name == w.category,
        orElse: () => WalletCategory.personal,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final balance =
          double.tryParse(_balanceController.text.replaceAll('.', '')) ?? 0.0;
      final description = _descriptionController.text.trim();

      if (_isEditMode) {
        await ref.read(walletNotifierProvider.notifier).updateWallet(
              widget.wallet!.copyWith(
                name: name,
                category: _selectedCategory.name,
                balance: balance,
                description: Value(description.isEmpty ? null : description),
                updatedAt: DateTime.now(),
              ),
            );
      } else {
        await ref.read(walletNotifierProvider.notifier).createWallet(
              name: name,
              category: _selectedCategory,
              initialBalance: balance,
              description: description.isEmpty ? null : description,
            );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Dompet berhasil diperbarui'
                  : 'Dompet berhasil ditambahkan',
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
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Dompet' : 'Tambah Dompet'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Nama Dompet ───────────────────
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Dompet',
                hintText: 'Contoh: BCA Tabungan',
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Nama dompet tidak boleh kosong';
                }
                if (v.trim().length < 2) {
                  return 'Nama minimal 2 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ── Kategori ──────────────────────
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _CategorySelector(
              selected: _selectedCategory,
              onChanged: (cat) => setState(() => _selectedCategory = cat),
            ),

            const SizedBox(height: 16),

            // ── Saldo Awal ────────────────────
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Saldo',
                hintText: '0',
                prefixIcon: Icon(Icons.payments_outlined),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Saldo tidak boleh kosong';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ── Deskripsi (opsional) ──────────
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (opsional)',
                hintText: 'Contoh: Rekening utama gajian',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 32),

            // ── Submit Button ─────────────────
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEditMode ? AppStrings.save : 'Tambah Dompet',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CATEGORY SELECTOR WIDGET
// ─────────────────────────────────────────────

class _CategorySelector extends StatelessWidget {
  final WalletCategory selected;
  final ValueChanged<WalletCategory> onChanged;

  const _CategorySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: WalletCategory.values.map((cat) {
        final isSelected = selected == cat;
        final color = _colorFor(cat);

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? color : AppColors.divider,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _iconFor(cat),
                    color: isSelected ? color : AppColors.textSecondary,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labelFor(cat),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? color : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _colorFor(WalletCategory cat) {
    switch (cat) {
      case WalletCategory.personal:
        return AppColors.personal;
      case WalletCategory.shared:
        return AppColors.shared;
      case WalletCategory.emergency:
        return AppColors.emergency;
    }
  }

  IconData _iconFor(WalletCategory cat) {
    switch (cat) {
      case WalletCategory.personal:
        return Icons.person_outline;
      case WalletCategory.shared:
        return Icons.people_outline;
      case WalletCategory.emergency:
        return Icons.shield_outlined;
    }
  }

  String _labelFor(WalletCategory cat) {
    switch (cat) {
      case WalletCategory.personal:
        return AppStrings.categoryPersonal;
      case WalletCategory.shared:
        return AppStrings.categoryShared;
      case WalletCategory.emergency:
        return AppStrings.categoryEmergency;
    }
  }
}
