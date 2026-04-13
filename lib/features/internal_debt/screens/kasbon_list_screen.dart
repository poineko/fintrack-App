// lib/features/internal_debt/screens/kasbon_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/internal_debt_provider.dart';
import '../widgets/kasbon_tile.dart';
import 'kasbon_form_screen.dart';
import 'repay_kasbon_screen.dart';

class KasbonListScreen extends ConsumerStatefulWidget {
  const KasbonListScreen({super.key});

  @override
  ConsumerState<KasbonListScreen> createState() =>
      _KasbonListScreenState();
}

class _KasbonListScreenState extends ConsumerState<KasbonListScreen>
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
    final activeDebtsAsync = ref.watch(activeDebtsProvider);
    final allDebtsAsync = ref.watch(allDebtsProvider);
    final totalDebtAsync = ref.watch(totalActiveDebtProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navKasbon),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const KasbonFormScreen(),
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
          // ── Total Kasbon Header ────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.active.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.active,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Kasbon Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    totalDebtAsync.when(
                      loading: () => const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2),
                      ),
                      error: (_, __) =>
                          const Text('Error'),
                      data: (total) => Text(
                        CurrencyFormatter.format(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.active,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Tab Views ─────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Kasbon Aktif
                _KasbonList(
                  debtsAsync: activeDebtsAsync,
                  emptyMessage: 'Tidak ada kasbon aktif 🎉',
                  emptySubMessage: 'Semua kasbon sudah lunas',
                  onRepay: (debt) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RepayKasbonScreen(debt: debt),
                    ),
                  ),
                ),

                // Tab 2: Semua Kasbon
                _KasbonList(
                  debtsAsync: allDebtsAsync,
                  emptyMessage: 'Belum ada kasbon',
                  emptySubMessage: 'Tap + untuk ambil kasbon',
                  onRepay: (debt) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RepayKasbonScreen(debt: debt),
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
            builder: (_) => const KasbonFormScreen(),
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Ambil Kasbon'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// KASBON LIST WIDGET
// ─────────────────────────────────────────────

class _KasbonList extends StatelessWidget {
  final AsyncValue<List<InternalDebt>> debtsAsync;
  final String emptyMessage;
  final String emptySubMessage;
  final void Function(InternalDebt) onRepay;

  const _KasbonList({
    required this.debtsAsync,
    required this.emptyMessage,
    required this.emptySubMessage,
    required this.onRepay,
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
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emptySubMessage,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: debts.length,
          itemBuilder: (context, index) {
            final debt = debts[index];
            return KasbonTile(
              debt: debt,
              onRepay: debt.status != 'settled'
                  ? () => onRepay(debt)
                  : null,
            );
          },
        );
      },
    );
  }
}