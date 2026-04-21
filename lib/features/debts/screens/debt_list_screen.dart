// lib/features/debts/screens/debt_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/debt_provider.dart';
import '../widgets/debt_tile.dart';
import 'debt_form_screen.dart';
import 'pay_debt_screen.dart';

class DebtListScreen extends ConsumerStatefulWidget {
  const DebtListScreen({super.key});

  @override
  ConsumerState<DebtListScreen> createState() =>
      _DebtListScreenState();
}

class _DebtListScreenState
    extends ConsumerState<DebtListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activeMyDebtsProvider);
    final allAsync = ref.watch(allMyDebtsProvider);
    final totalAsync = ref.watch(totalMyDebtProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hutang Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const DebtFormScreen(),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Semua'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Total Header ─────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.expense.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(Icons.credit_card_outlined,
                    color: AppColors.expense),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Hutang Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    totalAsync.when(
                      loading: () => const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2),
                      ),
                      error: (_, __) => const Text('Error'),
                      data: (total) => Text(
                        CurrencyFormatter.format(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.expense,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _DebtList(
                  debtsAsync: activeAsync,
                  emptyMessage: 'Tidak ada hutang aktif 🎉',
                  emptySubMessage: 'Semua hutang sudah lunas',
                  onPay: (d) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PayDebtScreen(debt: d),
                    ),
                  ),
                ),
                _DebtList(
                  debtsAsync: allAsync,
                  emptyMessage: 'Belum ada hutang tercatat',
                  emptySubMessage:
                      'Tap + untuk catat hutang baru',
                  onPay: (d) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PayDebtScreen(debt: d),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const DebtFormScreen(),
          ),
        ),
        backgroundColor: AppColors.expense,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Catat Hutang'),
      ),
    );
  }
}

class _DebtList extends StatelessWidget {
  final AsyncValue<List<Debt>> debtsAsync;
  final String emptyMessage;
  final String emptySubMessage;
  final void Function(Debt) onPay;

  const _DebtList({
    required this.debtsAsync,
    required this.emptyMessage,
    required this.emptySubMessage,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return debtsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (debts) {
        if (debts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.credit_card_outlined,
                    size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text(emptyMessage,
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(emptySubMessage,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textHint)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: debts.length,
          itemBuilder: (context, index) => DebtTile(
            debt: debts[index],
            onPay: debts[index].status != 'settled'
                ? () => onPay(debts[index])
                : null,
          ),
        );
      },
    );
  }
}