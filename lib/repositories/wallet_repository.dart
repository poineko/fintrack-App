// lib/repositories/wallet_repository.dart
import 'package:drift/drift.dart';
import '../core/constants/enums.dart';
import '../core/database/app_database.dart';

class WalletRepository {
  final AppDatabase _db;

  WalletRepository(this._db);

  // ─────────────────────────────────────────
  // READ
  // ─────────────────────────────────────────

  Stream<List<Wallet>> watchAllWallets() {
    return (_db.select(_db.wallets)
          ..where((w) => w.isActive.equals(true))
          ..orderBy([
            (w) => OrderingTerm(expression: w.category),
            (w) => OrderingTerm(expression: w.name),
          ]))
        .watch();
  }

  Stream<List<Wallet>> watchWalletsByCategory(WalletCategory category) {
    return (_db.select(_db.wallets)
          ..where((w) =>
              w.isActive.equals(true) & w.category.equals(category.name)))
        .watch();
  }

  Future<Wallet?> getWalletById(int id) {
    return (_db.select(_db.wallets)..where((w) => w.id.equals(id)))
        .getSingleOrNull();
  }

  Future<double> getTotalBalance() async {
    final wallets = await (_db.select(_db.wallets)
          ..where((w) => w.isActive.equals(true)))
        .get();
    // Explicit cast double untuk menghindari FutureOr issue
    return wallets.fold<double>(0.0, (sum, w) => sum + w.balance);
  }

  Future<double> getTotalBalanceByCategory(WalletCategory category) async {
    final wallets = await (_db.select(_db.wallets)
          ..where((w) =>
              w.isActive.equals(true) & w.category.equals(category.name)))
        .get();
    return wallets.fold<double>(0.0, (sum, w) => sum + w.balance);
  }

  /// Stream total saldo semua wallet — REAKTIF
  Stream<double> watchTotalBalance() {
    return (_db.select(_db.wallets)..where((w) => w.isActive.equals(true)))
        .watch()
        .map((wallets) =>
            wallets.fold<double>(0.0, (sum, w) => sum + w.balance));
  }

  /// Stream total saldo per kategori — REAKTIF
  Stream<double> watchTotalBalanceByCategory(WalletCategory category) {
    return (_db.select(_db.wallets)
          ..where((w) =>
              w.isActive.equals(true) & w.category.equals(category.name)))
        .watch()
        .map((wallets) =>
            wallets.fold<double>(0.0, (sum, w) => sum + w.balance));
  }

  // ─────────────────────────────────────────
  // CREATE
  // ─────────────────────────────────────────

  Future<int> createWallet(WalletsCompanion wallet) {
    return _db.into(_db.wallets).insert(wallet);
  }

  // ─────────────────────────────────────────
  // UPDATE
  // ─────────────────────────────────────────

  Future<bool> updateWallet(WalletsCompanion wallet) {
    return _db.update(_db.wallets).replace(wallet);
  }

  Future<void> updateBalance(int walletId, double newBalance) async {
    await (_db.update(_db.wallets)..where((w) => w.id.equals(walletId)))
        .write(WalletsCompanion(
      balance: Value(newBalance),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> adjustBalance(int walletId, double delta) async {
    final wallet = await getWalletById(walletId);
    if (wallet == null) throw Exception('Wallet tidak ditemukan: $walletId');
    await updateBalance(walletId, wallet.balance + delta);
  }

  // ─────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────

  Future<void> deactivateWallet(int walletId) async {
    await (_db.update(_db.wallets)..where((w) => w.id.equals(walletId)))
        .write(WalletsCompanion(
      isActive: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Cek apakah wallet masih punya transaksi aktif
  Future<bool> hasActiveTransactions(int walletId, AppDatabase db) async {
    final txs = await (db.select(db.transactions)
          ..where((t) =>
              t.isDeleted.equals(false) &
              (t.sourceWalletId.equals(walletId) |
                  t.destinationWalletId.equals(walletId))))
        .get();
    return txs.isNotEmpty;
  }
}
