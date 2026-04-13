// lib/repositories/receivable_repository.dart
import 'package:drift/drift.dart';
import '../core/constants/enums.dart';
import '../core/database/app_database.dart';
import 'wallet_repository.dart';

class ReceivableRepository {
  final AppDatabase _db;
  final WalletRepository _walletRepo;

  ReceivableRepository(this._db, this._walletRepo);

  // ─────────────────────────────────────────
  // READ
  // ─────────────────────────────────────────

  Stream<List<Receivable>> watchActiveReceivables() {
    return (_db.select(_db.receivables)
          ..where((r) =>
              r.status.equals(ReceivableStatus.active.name) |
              r.status.equals(ReceivableStatus.partiallyCollected.name))
          ..orderBy([
            (r) => OrderingTerm(expression: r.lentAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<Receivable>> watchAllReceivables() {
    return (_db.select(_db.receivables)
          ..orderBy([
            (r) => OrderingTerm(expression: r.lentAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Stream total piutang aktif — REAKTIF
  Stream<double> watchTotalActiveReceivables() {
    return (_db.select(_db.receivables)
          ..where((r) =>
              r.status.equals(ReceivableStatus.active.name) |
              r.status.equals(ReceivableStatus.partiallyCollected.name)))
        .watch()
        .map((items) =>
            items.fold<double>(0.0, (sum, r) => sum + r.remainingAmount));
  }

  Future<Receivable?> getReceivableById(int id) {
    return (_db.select(_db.receivables)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  Future<double> getTotalActiveReceivables() async {
    final items = await (_db.select(_db.receivables)
          ..where((r) =>
              r.status.equals(ReceivableStatus.active.name) |
              r.status.equals(ReceivableStatus.partiallyCollected.name)))
        .get();
    return items.fold<double>(0.0, (sum, r) => sum + r.remainingAmount);
  }

  // ─────────────────────────────────────────
  // CREATE — Catat Piutang Baru
  // ─────────────────────────────────────────

  Future<void> createReceivable({
    required String borrowerName,
    required double amount,
    required int sourceWalletId,
    required String uuid,
    String? borrowerContact,
    DateTime? targetReturnDate,
    String? purpose,
    String? note,
  }) async {
    await _db.transaction(() async {
      final sourceWallet = await _walletRepo.getWalletById(sourceWalletId);
      if (sourceWallet == null) throw Exception('Wallet tidak ditemukan');
      if (sourceWallet.balance < amount) {
        throw Exception('Saldo tidak cukup untuk meminjamkan uang');
      }

      // 1. Kurangi saldo wallet sumber
      await _walletRepo.adjustBalance(sourceWalletId, -amount);

      // 2. Catat Receivable
      final receivableId = await _db.into(_db.receivables).insert(
            ReceivablesCompanion.insert(
              borrowerName: borrowerName,
              borrowerContact: Value(borrowerContact),
              originalAmount: amount,
              remainingAmount: amount,
              sourceWalletId: sourceWalletId,
              lentAt: DateTime.now(),
              targetReturnDate: Value(targetReturnDate),
              purpose: Value(purpose),
              note: Value(note),
            ),
          );

      // 3. Catat Transaction
      await _db.into(_db.transactions).insert(
            TransactionsCompanion.insert(
              uuid: uuid,
              type: 'expense',
              category: TransactionCategory.receivableGiven.name,
              amount: amount,
              description: 'Piutang ke $borrowerName',
              date: DateTime.now(),
              sourceWalletId: Value(sourceWalletId),
              relatedReceivableId: Value(receivableId),
              note: Value(note),
            ),
          );
    });
  }

  // ─────────────────────────────────────────
  // COLLECT — Terima Pembayaran Piutang
  // ─────────────────────────────────────────

  Future<void> collectReceivable({
    required int receivableId,
    required double collectAmount,
    required int targetWalletId,
    required String uuid,
    String? note,
  }) async {
    await _db.transaction(() async {
      final receivable = await getReceivableById(receivableId);
      if (receivable == null) throw Exception('Piutang tidak ditemukan');
      if (receivable.status == ReceivableStatus.collected.name) {
        throw Exception('Piutang sudah lunas');
      }
      if (collectAmount > receivable.remainingAmount) {
        throw Exception('Jumlah melebihi sisa piutang');
      }

      // 1. Tambah saldo wallet tujuan
      await _walletRepo.adjustBalance(targetWalletId, collectAmount);

      // 2. Update receivable
      final newRemaining = receivable.remainingAmount - collectAmount;
      final newStatus = newRemaining <= 0
          ? ReceivableStatus.collected.name
          : ReceivableStatus.partiallyCollected.name;

      await (_db.update(_db.receivables)
            ..where((r) => r.id.equals(receivableId)))
          .write(ReceivablesCompanion(
        remainingAmount: Value(newRemaining),
        status: Value(newStatus),
        collectedAt:
            newRemaining <= 0 ? Value(DateTime.now()) : const Value.absent(),
      ));

      // 3. Catat Transaction penerimaan
      await _db.into(_db.transactions).insert(
            TransactionsCompanion.insert(
              uuid: uuid,
              type: 'income',
              category: TransactionCategory.receivableCollection.name,
              amount: collectAmount,
              description: 'Terima piutang dari ${receivable.borrowerName}',
              date: DateTime.now(),
              sourceWalletId: Value(targetWalletId),
              relatedReceivableId: Value(receivableId),
              note: Value(note),
            ),
          );
    });
  }

  /// Write-off piutang — tandai tidak bisa ditagih
  /// Saldo TIDAK dikembalikan ke wallet
  Future<void> writeOffReceivable(int receivableId) async {
    await (_db.update(_db.receivables)
          ..where((r) => r.id.equals(receivableId)))
        .write(ReceivablesCompanion(
      status: Value(ReceivableStatus.writeOff.name),
      collectedAt: Value(DateTime.now()),
    ));
  }
}
