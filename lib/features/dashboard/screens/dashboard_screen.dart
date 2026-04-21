// lib/features/dashboard/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_helper.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/internal_debt_provider.dart';
import '../widgets/financial_chart.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/wallet_summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final activeDebtsAsync = ref.watch(activeDebtsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            // ── App Bar ───────────────────────────
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: _HeaderCard(summaryAsync: summaryAsync),
              ),
              title: const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ── Ringkasan Per Kategori ─────
                  summaryAsync.when(
                    loading: () => const _LoadingSection(),
                    error: (e, _) => _ErrorSection(message: e.toString()),
                    data: (summary) =>
                        _CategorySummarySection(summary: summary),
                  ),

                  const SizedBox(height: 12), // ← Konsisten

                  // ── Kasbon Aktif ───────────────
                  activeDebtsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (debts) => debts.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ActiveKasbonSection(
                              totalDebt: debts.fold<double>(
                                  0, (s, d) => s + d.remainingAmount),
                              count: debts.length,
                              onTap: () => context.go('/kasbon'),
                            ),
                          ),
                  ),

                  // ── Chart ─────────────────────
                  const FinancialChart(),

                  const SizedBox(height: 12),

                  // ── Transaksi Terakhir ─────────
                  const Card(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: RecentTransactions(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER — Total Saldo
// ─────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  final AsyncValue<DashboardSummary> summaryAsync;

  const _HeaderCard({required this.summaryAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
          child: summaryAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (e, _) => Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
            data: (summary) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Total Kekayaan Bersih',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(summary.netWorth),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Aset: ${CurrencyFormatter.format(summary.totalBalance)}',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateHelper.formatMonth(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CATEGORY SUMMARY
// ─────────────────────────────────────────────

class _CategorySummarySection extends StatelessWidget {
  final DashboardSummary summary;

  const _CategorySummarySection({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Saldo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // ── Row 1 ──────────────────────
          IntrinsicHeight(
            // ← Pastikan tinggi sama
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: WalletSummaryCard(
                    title: AppStrings.categoryPersonal,
                    amount: summary.totalPersonal,
                    color: AppColors.personal,
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: WalletSummaryCard(
                    title: AppStrings.categoryShared,
                    amount: summary.totalShared,
                    color: AppColors.shared,
                    icon: Icons.people_outline,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Row 2 ──────────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: WalletSummaryCard(
                    title: AppStrings.categoryEmergency,
                    amount: summary.totalEmergency,
                    color: AppColors.emergency,
                    icon: Icons.shield_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SavingsRatioCard(summary: summary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pisahkan ke widget sendiri ────────────
class _SavingsRatioCard extends StatelessWidget {
  final DashboardSummary summary;

  const _SavingsRatioCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final color = summary.isDeficit ? AppColors.expense : AppColors.income;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                summary.isDeficit
                    ? Icons.trending_down
                    : Icons.savings_outlined,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  summary.isDeficit ? 'Defisit' : 'Rasio Hemat',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            summary.isDeficit
                ? '-${summary.savingsRatio.abs().toStringAsFixed(1)}%'
                : '${summary.savingsRatio.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            'bulan ini',
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// KASBON AKTIF BANNER
// ─────────────────────────────────────────────

class _ActiveKasbonSection extends StatelessWidget {
  final double totalDebt;
  final int count;
  final VoidCallback? onTap; // ← TAMBAH INI

  const _ActiveKasbonSection({
    required this.totalDebt,
    required this.count,
    this.onTap, // ← TAMBAH INI
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ← TAMBAH INI
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.active.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.active.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.active,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count Kasbon Aktif',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.active,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Total: ${CurrencyFormatter.format(totalDebt)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HELPER WIDGETS
// ─────────────────────────────────────────────

class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  final String message;

  const _ErrorSection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: AppColors.expense.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.expense),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: AppColors.expense),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
