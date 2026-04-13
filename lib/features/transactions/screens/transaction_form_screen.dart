// lib/features/transactions/screens/transaction_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/enums.dart';
import '../../../core/database/app_database.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/wallet_provider.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  /// Jika null = mode tambah, jika ada isi = mode edit
  final Transaction? transaction;

  const TransactionFormScreen({super.key, this.transaction});

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();

  late final TextEditingController _dateController;
  late TabController _tabController;

  TransactionType _selectedType = TransactionType.expense;
  TransactionCategory _selectedCategory = TransactionCategory.food;
  Wallet? _sourceWallet;
  Wallet? _destinationWallet;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final _uuid = const Uuid();

  bool get _isEditMode => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    // ── Inisialisasi date controller dulu ──
    _dateController = TextEditingController(
      text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
    );

    // ── Tentukan initial tab index ──────────
    int initialIndex = 0;
    if (widget.transaction != null) {
      switch (widget.transaction!.type) {
        case 'income':
          initialIndex = 1;
        case 'transfer':
          initialIndex = 2;
        default:
          initialIndex = 0;
      }
    }

    // ── Buat TabController SEKALI ──────────
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _selectedType = TransactionType.expense;
              _selectedCategory = TransactionCategory.food;
            case 1:
              _selectedType = TransactionType.income;
              _selectedCategory = TransactionCategory.salary;
            case 2:
              _selectedType = TransactionType.transfer;
              _selectedCategory = TransactionCategory.other;
          }
        });
      }
    });

    // ── Isi form jika mode edit ────────────
    if (widget.transaction != null) {
      final tx = widget.transaction!;
      _amountController.text = tx.amount.toStringAsFixed(0);
      _descriptionController.text = tx.description;
      _noteController.text = tx.note ?? '';
      _selectedDate = tx.date;
      _dateController.text = '${tx.date.day}/${tx.date.month}/${tx.date.year}';

      // Set tipe & kategori
      switch (tx.type) {
        case 'expense':
          _selectedType = TransactionType.expense;
          _selectedCategory = TransactionCategory.values.firstWhere(
            (c) => c.name == tx.category,
            orElse: () => TransactionCategory.food,
          );
        case 'income':
          _selectedType = TransactionType.income;
          _selectedCategory = TransactionCategory.values.firstWhere(
            (c) => c.name == tx.category,
            orElse: () => TransactionCategory.salary,
          );
        case 'transfer':
          _selectedType = TransactionType.transfer;
          _selectedCategory = TransactionCategory.other;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  List<TransactionCategory> get _categoriesForType {
    switch (_selectedType) {
      case TransactionType.expense:
        return [
          TransactionCategory.food,
          TransactionCategory.transport,
          TransactionCategory.shopping,
          TransactionCategory.bills,
          TransactionCategory.health,
          TransactionCategory.entertainment,
          TransactionCategory.education,
          TransactionCategory.other,
        ];
      case TransactionType.income:
        return [
          TransactionCategory.salary,
          TransactionCategory.freelance,
          TransactionCategory.investment,
          TransactionCategory.gift,
          TransactionCategory.refund,
          TransactionCategory.other,
        ];
      case TransactionType.transfer:
        return [TransactionCategory.other];
    }
  }

  String _categoryLabel(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.food:
        return '🍔 Makanan';
      case TransactionCategory.transport:
        return '🚗 Transportasi';
      case TransactionCategory.shopping:
        return '🛍️ Belanja';
      case TransactionCategory.bills:
        return '📋 Tagihan';
      case TransactionCategory.health:
        return '🏥 Kesehatan';
      case TransactionCategory.entertainment:
        return '🎮 Hiburan';
      case TransactionCategory.education:
        return '📚 Pendidikan';
      case TransactionCategory.salary:
        return '💼 Gaji';
      case TransactionCategory.freelance:
        return '💻 Freelance';
      case TransactionCategory.investment:
        return '📈 Investasi';
      case TransactionCategory.gift:
        return '🎁 Hadiah';
      case TransactionCategory.refund:
        return '↩️ Refund';
      default:
        return '📦 Lainnya';
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_sourceWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih wallet sumber dana'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }
    if (_selectedType == TransactionType.transfer &&
        _destinationWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih wallet tujuan transfer'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }
    if (_selectedType == TransactionType.transfer &&
        _sourceWallet?.id == _destinationWallet?.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallet sumber dan tujuan tidak boleh sama'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount =
          double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0.0;
      final description = _descriptionController.text.trim();
      final note = _noteController.text.trim();
      final notifier = ref.read(transactionNotifierProvider.notifier);

      if (_isEditMode) {
        // ── MODE EDIT ──────────────────────
        await notifier.editTransaction(
          transactionId: widget.transaction!.id,
          description: description,
          newAmount: amount,
          newSourceWalletId: _sourceWallet!.id,
          newCategory: _selectedCategory,
          newDate: _selectedDate,
          newDestinationWalletId: _destinationWallet?.id,
          note: note.isEmpty ? null : note,
        );
      } else {
        // ── MODE TAMBAH ────────────────────
        final uuid = _uuid.v4();
        switch (_selectedType) {
          case TransactionType.expense:
            await notifier.addExpense(
              uuid: uuid,
              description: description,
              amount: amount,
              sourceWalletId: _sourceWallet!.id,
              category: _selectedCategory,
              date: _selectedDate,
              note: note.isEmpty ? null : note,
            );
          case TransactionType.income:
            await notifier.addIncome(
              uuid: uuid,
              description: description,
              amount: amount,
              targetWalletId: _sourceWallet!.id,
              category: _selectedCategory,
              date: _selectedDate,
              note: note.isEmpty ? null : note,
            );
          case TransactionType.transfer:
            await notifier.addTransfer(
              uuid: uuid,
              description: description,
              amount: amount,
              sourceWalletId: _sourceWallet!.id,
              destinationWalletId: _destinationWallet!.id,
              date: _selectedDate,
              note: note.isEmpty ? null : note,
            );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Transaksi berhasil diperbarui'
                  : 'Transaksi berhasil dicatat',
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
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: '  Pengeluaran  '),
            Tab(text: '  Pemasukan  '),
            Tab(text: '  Transfer  '),
          ],
        ),
      ),
      body: walletsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (wallets) {
          if (wallets.isEmpty) {
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
                      'Buat dompet dulu sebelum mencatat transaksi',
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
                // ── Jumlah ──────────────────────
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    prefixText: 'Rp ',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    fillColor: _selectedType == TransactionType.expense
                        ? AppColors.expense.withValues(alpha: 0.05)
                        : _selectedType == TransactionType.income
                            ? AppColors.income.withValues(alpha: 0.05)
                            : AppColors.transfer.withValues(alpha: 0.05),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    fontSize: 20,
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

                // ── Deskripsi ────────────────────
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                    hintText: 'Contoh: Makan siang di warung',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Keterangan tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Kategori (sembunyikan saat transfer) ──
                if (_selectedType != TransactionType.transfer) ...[
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categoriesForType.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      final color = _selectedType == TransactionType.expense
                          ? AppColors.expense
                          : AppColors.income;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? color : AppColors.divider,
                            ),
                          ),
                          child: Text(
                            _categoryLabel(cat),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isSelected ? color : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Wallet Sumber ────────────────
                _WalletDropdown(
                  label: _selectedType == TransactionType.income
                      ? 'Masuk ke Dompet'
                      : 'Dari Dompet',
                  wallets: wallets,
                  selected: _sourceWallet,
                  onChanged: (w) => setState(() => _sourceWallet = w),
                ),

                // ── Wallet Tujuan (hanya transfer) ──
                if (_selectedType == TransactionType.transfer) ...[
                  const SizedBox(height: 16),
                  _WalletDropdown(
                    label: 'Ke Dompet',
                    wallets: wallets
                        .where((w) => w.id != _sourceWallet?.id)
                        .toList(),
                    selected: _destinationWallet,
                    onChanged: (w) => setState(() => _destinationWallet = w),
                  ),
                ],

                const SizedBox(height: 16),

                // ── Tanggal ──────────────────────
                InkWell(
                  onTap: _pickDate,
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Catatan (opsional) ────────────
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
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedType == TransactionType.expense
                          ? AppColors.expense
                          : _selectedType == TransactionType.income
                              ? AppColors.income
                              : AppColors.transfer,
                    ),
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
                            _isEditMode
                                ? 'Simpan Perubahan'
                                : 'Simpan ${_selectedType == TransactionType.expense ? "Pengeluaran" : _selectedType == TransactionType.income ? "Pemasukan" : "Transfer"}',
                            style: const TextStyle(fontSize: 16),
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
// WALLET DROPDOWN WIDGET
// ─────────────────────────────────────────────

class _WalletDropdown extends StatelessWidget {
  final String label;
  final List<Wallet> wallets;
  final Wallet? selected;
  final ValueChanged<Wallet?> onChanged;

  const _WalletDropdown({
    required this.label,
    required this.wallets,
    required this.selected,
    required this.onChanged,
  });

  Color _categoryColor(String category) {
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
    // Cari wallet yang cocok berdasarkan ID — bukan object reference
    final currentValue = selected == null
        ? null
        : wallets.where((w) => w.id == selected!.id).firstOrNull;

    return DropdownButtonFormField<Wallet>(
      initialValue: currentValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
      ),
      hint: Text('Pilih $label'),
      isExpanded: true,
      items: wallets.map((wallet) {
        final color = _categoryColor(wallet.category);
        return DropdownMenuItem<Wallet>(
          value: wallet,
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
                  wallet.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Rp ${wallet.balance.toStringAsFixed(0)}',
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
