// lib/features/transactions/screens/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/transaction_provider.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_form_screen.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(filteredTransactionsProvider);
    final filter = ref.watch(transactionFilterProvider);
    final expenseAsync = ref.watch(totalExpenseThisMonthProvider);
    final incomeAsync = ref.watch(totalIncomeThisMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navTransactions),
        actions: [
          // Filter indicator badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterSheet(context, ref),
              ),
              if (filter.isActive)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TransactionFormScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Active Filter Chips ────────────
          if (filter.isActive)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const Text(
                    'Filter: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (filter.type != null)
                    _FilterChip(
                      label: _typeLabel(filter.type!),
                      onRemove: () => ref
                          .read(transactionFilterProvider.notifier)
                          .state = filter.copyWith(clearType: true),
                    ),
                  if (filter.category != null)
                    _FilterChip(
                      label: _categoryLabel(filter.category!),
                      onRemove: () => ref
                          .read(transactionFilterProvider.notifier)
                          .state = filter.copyWith(clearCategory: true),
                    ),
                  if (filter.startDate != null || filter.endDate != null)
                    _FilterChip(
                      label:
                          '${filter.startDate != null ? DateHelper.formatShort(filter.startDate!) : '...'} - ${filter.endDate != null ? DateHelper.formatShort(filter.endDate!) : '...'}',
                      onRemove: () => ref
                          .read(transactionFilterProvider.notifier)
                          .state = filter.copyWith(clearDates: true),
                    ),
                  TextButton(
                    onPressed: () => ref
                        .read(transactionFilterProvider.notifier)
                        .state = const TransactionFilter(),
                    child: const Text(
                      'Reset Semua',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // ── Summary Header ─────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryChip(
                    label: 'Pemasukan',
                    valueAsync: incomeAsync,
                    color: AppColors.income,
                    icon: Icons.arrow_downward_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryChip(
                    label: 'Pengeluaran',
                    valueAsync: expenseAsync,
                    color: Colors.red.shade300,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
          ),

          // ── Transaction List ───────────────
          Expanded(
            child: txAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          filter.isActive
                              ? 'Tidak ada transaksi\nsesuai filter'
                              : AppStrings.noData,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        if (!filter.isActive) ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TransactionFormScreen(),
                              ),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Catat Transaksi'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                final grouped = _groupByDate(transactions);

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final entry = grouped[index];
                    return _DateGroup(
                      date: entry.key,
                      transactions: entry.value,
                      onDelete: (tx) => ref
                          .read(transactionNotifierProvider.notifier)
                          .deleteTransaction(tx.id),
                      onEdit: (tx) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              TransactionFormScreen(transaction: tx),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const TransactionFormScreen(),
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Catat'),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _FilterSheet(ref: ref),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'income':
        return 'Pemasukan';
      case 'expense':
        return 'Pengeluaran';
      case 'transfer':
        return 'Transfer';
      default:
        return type;
    }
  }

  String _categoryLabel(String cat) {
    switch (cat) {
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
      default:
        return cat;
    }
  }

  List<MapEntry<DateTime, List<Transaction>>> _groupByDate(
    List<Transaction> txs,
  ) {
    final Map<DateTime, List<Transaction>> map = {};
    for (final tx in txs) {
      final date = DateTime(tx.date.year, tx.date.month, tx.date.day);
      map.putIfAbsent(date, () => []).add(tx);
    }
    return map.entries.toList()..sort((a, b) => b.key.compareTo(a.key));
  }
}

// ─────────────────────────────────────────────
// FILTER SHEET
// ─────────────────────────────────────────────

class _FilterSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _FilterSheet({required this.ref});

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  String? _selectedType;
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final filter = widget.ref.read(transactionFilterProvider);
    _selectedType = filter.type;
    _selectedCategory = filter.category;
    _startDate = filter.startDate;
    _endDate = filter.endDate;
  }

  void _apply() {
    widget.ref.read(transactionFilterProvider.notifier).state =
        TransactionFilter(
      type: _selectedType,
      category: _selectedCategory,
      startDate: _startDate,
      endDate: _endDate,
    );
    Navigator.pop(context);
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Filter Transaksi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // ── Tipe ──────────────────────────
          const Text(
            'Tipe',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['income', 'expense', 'transfer']
                .map((type) => _TypeChip(
                      label: type == 'income'
                          ? 'Pemasukan'
                          : type == 'expense'
                              ? 'Pengeluaran'
                              : 'Transfer',
                      isSelected: _selectedType == type,
                      color: type == 'income'
                          ? AppColors.income
                          : type == 'expense'
                              ? AppColors.expense
                              : AppColors.transfer,
                      onTap: () => setState(() {
                        _selectedType = _selectedType == type ? null : type;
                        _selectedCategory = null;
                      }),
                    ))
                .toList(),
          ),

          const SizedBox(height: 16),

          // ── Rentang Tanggal ───────────────
          const Text(
            'Rentang Tanggal',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(true),
                  icon: const Icon(Icons.calendar_today, size: 14),
                  label: Text(
                    _startDate != null
                        ? DateHelper.formatShort(_startDate!)
                        : 'Dari',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('—'),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(false),
                  icon: const Icon(Icons.calendar_today, size: 14),
                  label: Text(
                    _endDate != null
                        ? DateHelper.formatShort(_endDate!)
                        : 'Sampai',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              if (_startDate != null || _endDate != null)
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => setState(() {
                    _startDate = null;
                    _endDate = null;
                  }),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Apply Button ──────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = null;
                      _selectedCategory = null;
                      _startDate = null;
                      _endDate = null;
                    });
                    widget.ref.read(transactionFilterProvider.notifier).state =
                        const TransactionFilter();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _apply,
                  child: const Text('Terapkan Filter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSE WIDGETS DARI SEBELUMNYA
// ─────────────────────────────────────────────

class _DateGroup extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final void Function(Transaction) onDelete;
  final void Function(Transaction) onEdit;

  const _DateGroup({
    required this.date,
    required this.transactions,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dayTotal = transactions.fold<double>(0, (sum, tx) {
      if (tx.type == 'income') return sum + tx.amount;
      if (tx.type == 'expense') return sum - tx.amount;
      return sum;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateHelper.formatRelative(date),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${dayTotal >= 0 ? '+' : ''}${CurrencyFormatter.format(dayTotal)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: dayTotal >= 0 ? AppColors.income : AppColors.expense,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ...transactions.map((tx) => TransactionTile(
              transaction: tx,
              onDelete: () => onDelete(tx),
              onEdit: () => onEdit(tx),
            )),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final AsyncValue<double> valueAsync;
  final Color color;
  final IconData icon;

  const _SummaryChip({
    required this.label,
    required this.valueAsync,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                valueAsync.when(
                  loading: () => const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  error: (_, __) => const Text('-'),
                  data: (v) => Text(
                    CurrencyFormatter.compact(v),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
