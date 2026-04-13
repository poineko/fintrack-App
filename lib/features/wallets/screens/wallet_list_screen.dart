// lib/features/wallets/screens/wallet_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/enums.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/database/app_database.dart';
import '../../../providers/wallet_provider.dart';
import '../widgets/wallet_card.dart';
import 'wallet_form_screen.dart';
import 'wallet_detail_screen.dart';

class WalletListScreen extends ConsumerWidget {
  const WalletListScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int walletId,
    String walletName,
    double balance,
  ) async {
    // Cek apakah masih punya saldo
    final warnings = <String>[];
    if (balance > 0) {
      warnings
          .add('• Masih memiliki saldo ${CurrencyFormatter.format(balance)}');
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Dompet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yakin ingin menonaktifkan "$walletName"?'),
            if (warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.active.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Perhatian:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.active,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...warnings.map((w) => Text(
                          w,
                          style: const TextStyle(
                            color: AppColors.active,
                            fontSize: 12,
                          ),
                        )),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              'Histori transaksi tidak akan terhapus.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.expense,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(walletNotifierProvider.notifier)
          .deactivateWallet(walletId);
    }
  }

  Future<void> _openForm(BuildContext context, {Wallet? wallet}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WalletFormScreen(wallet: wallet),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(allWalletsProvider);
    final totalAsync = ref.watch(totalBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navWallets),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(context),
            tooltip: 'Tambah Dompet',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Total Saldo Header ─────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Semua Saldo',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                totalAsync.when(
                  loading: () => const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                  error: (_, __) => const Text(
                    'Error',
                    style: TextStyle(color: Colors.white),
                  ),
                  data: (total) => Text(
                    CurrencyFormatter.format(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Wallet List ────────────────────
          Expanded(
            child: walletsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Text('Error: $e'),
              ),
              data: (wallets) {
                if (wallets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada dompet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap + untuk menambahkan dompet pertama',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _openForm(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Dompet'),
                        ),
                      ],
                    ),
                  );
                }

                // Group by category
                final categories = [
                  WalletCategory.personal,
                  WalletCategory.shared,
                  WalletCategory.emergency,
                ];

                return ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  children: categories.map((cat) {
                    final catWallets =
                        wallets.where((w) => w.category == cat.name).toList();

                    if (catWallets.isEmpty) return const SizedBox.shrink();

                    final catTotal =
                        catWallets.fold<double>(0, (s, w) => s + w.balance);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _categoryLabel(cat),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _categoryColor(cat),
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(catTotal),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _categoryColor(cat),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Wallet Cards
                        ...catWallets.map((wallet) => WalletCard(
                              wallet: wallet,
                              onTap: () => Navigator.of(context).push(
                                // ← TAMBAH INI
                                MaterialPageRoute(
                                  builder: (_) =>
                                      WalletDetailScreen(wallet: wallet),
                                ),
                              ),
                              onEdit: () => _openForm(context, wallet: wallet),
                              onDelete: () => _confirmDelete(
                                context,
                                ref,
                                wallet.id,
                                wallet.name,
                                wallet.balance,
                              ),
                            )),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Dompet'),
      ),
    );
  }

  String _categoryLabel(WalletCategory cat) {
    switch (cat) {
      case WalletCategory.personal:
        return AppStrings.categoryPersonal;
      case WalletCategory.shared:
        return AppStrings.categoryShared;
      case WalletCategory.emergency:
        return AppStrings.categoryEmergency;
    }
  }

  Color _categoryColor(WalletCategory cat) {
    switch (cat) {
      case WalletCategory.personal:
        return AppColors.personal;
      case WalletCategory.shared:
        return AppColors.shared;
      case WalletCategory.emergency:
        return AppColors.emergency;
    }
  }
}
