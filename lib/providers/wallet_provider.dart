// lib/providers/wallet_provider.dart
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/enums.dart';
import '../core/database/app_database.dart';
import '../repositories/wallet_repository.dart';
import 'database_provider.dart';

// ─────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(ref.watch(databaseProvider));
});

// ─────────────────────────────────────────────
// STREAM PROVIDERS — reaktif, UI auto-rebuild
// ─────────────────────────────────────────────

/// Stream semua wallet aktif
final allWalletsProvider = StreamProvider<List<Wallet>>((ref) {
  return ref.watch(walletRepositoryProvider).watchAllWallets();
});

/// Stream wallet personal saja
final personalWalletsProvider = StreamProvider<List<Wallet>>((ref) {
  return ref
      .watch(walletRepositoryProvider)
      .watchWalletsByCategory(WalletCategory.personal);
});

/// Stream wallet shared saja
final sharedWalletsProvider = StreamProvider<List<Wallet>>((ref) {
  return ref
      .watch(walletRepositoryProvider)
      .watchWalletsByCategory(WalletCategory.shared);
});

/// Stream wallet emergency saja
final emergencyWalletsProvider = StreamProvider<List<Wallet>>((ref) {
  return ref
      .watch(walletRepositoryProvider)
      .watchWalletsByCategory(WalletCategory.emergency);
});

// ─────────────────────────────────────────────
// FUTURE PROVIDERS — untuk summary/total
// ─────────────────────────────────────────────

final totalBalanceProvider = StreamProvider<double>((ref) {
  return ref.watch(walletRepositoryProvider).watchTotalBalance();
});

final totalPersonalBalanceProvider = StreamProvider<double>((ref) {
  return ref
      .watch(walletRepositoryProvider)
      .watchTotalBalanceByCategory(WalletCategory.personal);
});

final totalSharedBalanceProvider = StreamProvider<double>((ref) {
  return ref
      .watch(walletRepositoryProvider)
      .watchTotalBalanceByCategory(WalletCategory.shared);
});

final totalEmergencyBalanceProvider = StreamProvider<double>((ref) {
  return ref
      .watch(walletRepositoryProvider)
      .watchTotalBalanceByCategory(WalletCategory.emergency);
});

// ─────────────────────────────────────────────
// NOTIFIER — untuk operasi CRUD
// ─────────────────────────────────────────────

class WalletNotifier extends StateNotifier<AsyncValue<void>> {
  final WalletRepository _repo;

  WalletNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createWallet({
    required String name,
    required WalletCategory category,
    double initialBalance = 0.0,
    String? iconCode,
    String? colorCode,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.createWallet(
          WalletsCompanion.insert(
            name: name,
            category: Value(category.name),
            balance: Value(initialBalance),
            iconCode: Value(iconCode),
            colorCode: Value(colorCode),
            description: Value(description),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        ));
  }

  Future<void> updateWallet(Wallet wallet) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.updateWallet(
          WalletsCompanion(
            id: Value(wallet.id),
            name: Value(wallet.name),
            category: Value(wallet.category),
            balance: Value(wallet.balance),
            iconCode: Value(wallet.iconCode),
            colorCode: Value(wallet.colorCode),
            description: Value(wallet.description),
            updatedAt: Value(DateTime.now()),
          ),
        ));
  }

  Future<void> deactivateWallet(int walletId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repo.deactivateWallet(walletId),
    );
  }
}

final walletNotifierProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<void>>((ref) {
  return WalletNotifier(ref.watch(walletRepositoryProvider));
});
