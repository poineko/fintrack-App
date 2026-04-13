// lib/features/receivables/screens/receivable_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/receivable_provider.dart';
import '../widgets/receivable_tile.dart';
import 'collect_receivable_screen.dart';
import 'receivable_form_screen.dart';

class ReceivableListScreen extends ConsumerStatefulWidget {
  const ReceivableListScreen({super.key});

  @override
  ConsumerState<ReceivableListScreen> createState() =>
      _ReceivableListScreenState();
}

class _ReceivableListScreenState extends ConsumerState<ReceivableListScreen>
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
    final activeAsync = ref.watch(activeReceivablesProvider);
    final allAsync = ref.watch(allReceivablesProvider);
    final totalAsync = ref.watch(totalActiveReceivablesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Piutang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ReceivableFormScreen(),
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
          // ── Total Header ───────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.income.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.income,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Piutang Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    totalAsync.when(
                      loading: () => const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => const Text('Error'),
                      data: (total) => Text(
                        CurrencyFormatter.format(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.income,
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
                // Tab 1 — Aktif
                _ReceivableList(
                  receivablesAsync: activeAsync,
                  emptyMessage: 'Tidak ada piutang aktif 🎉',
                  emptySubMessage: 'Semua piutang sudah kembali',
                  onCollect: (r) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CollectReceivableScreen(receivable: r),
                    ),
                  ),
                  onWriteOff: (Receivable r) =>
                      _confirmWriteOff(context, ref, r),
                ),

                // Tab 2 — Semua
                _ReceivableList(
                  receivablesAsync: allAsync,
                  emptyMessage: 'Belum ada piutang',
                  emptySubMessage: 'Tap + untuk catat piutang baru',
                  onCollect: (r) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CollectReceivableScreen(receivable: r),
                    ),
                  ),
                  onWriteOff: (Receivable r) =>
                      _confirmWriteOff(context, ref, r),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ReceivableFormScreen(),
          ),
        ),
        backgroundColor: AppColors.income,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Catat Piutang'),
      ),
    );
  }

  Future<void> _confirmWriteOff(
    BuildContext context,
    WidgetRef ref,
    Receivable receivable,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Piutang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tandai piutang ${receivable.borrowerName} sebagai tidak tertagih?',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.active.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '⚠️ Saldo wallet TIDAK akan dikembalikan. Gunakan ini jika piutang benar-benar tidak bisa ditagih.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.active,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.expense,
            ),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(receivableNotifierProvider.notifier)
          .writeOffReceivable(receivable.id);
    }
  }
}

class _ReceivableList extends StatelessWidget {
  final AsyncValue<List<Receivable>> receivablesAsync;
  final String emptyMessage;
  final String emptySubMessage;
  final void Function(Receivable) onCollect;
  final void Function(Receivable) onWriteOff;

  const _ReceivableList({
    required this.receivablesAsync,
    required this.emptyMessage,
    required this.emptySubMessage,
    required this.onCollect,
    required this.onWriteOff,
  });

  @override
  Widget build(BuildContext context) {
    return receivablesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (receivables) {
        if (receivables.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_outlined,
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
          itemCount: receivables.length,
          itemBuilder: (context, index) {
            final r = receivables[index];
            return ReceivableTile(
              receivable: r,
              onCollect: r.status != 'collected' && r.status != 'writeOff'
                  ? () => onCollect(r)
                  : null,
              onWriteOff: r.status != 'collected' && r.status != 'writeOff'
                  ? () => onWriteOff(r) // ← TAMBAH INI
                  : null,
            );
          },
        );
      },
    );
  }
}
