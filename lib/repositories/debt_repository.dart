// lib/repositories/debt_repository.dart
import 'package:drift/drift.dart';
import '../core/database/app_database.dart';
import 'wallet_repository.dart';

class DebtRepository {
  final AppDatabase _db;
  final WalletRepository _walletRepo;

  DebtRepository(this._db, this._walletRepo);

  // ── READ ────────────────────────────────

  Stream<List<Debt>> watchActiveDebts() {
    return (_db.select(_db.debts)
          ..where((d) =>
              d.status.equals('active') |
              d.status.equals('partiallyPaid'))
          ..orderBy([
            (d) => OrderingTerm(
                expression: d.borrowedAt,
                mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<Debt>> watchAllDebts() {
    return (_db.select(_db.debts)
          ..orderBy([
            (d) => OrderingTerm(
                expression: d.borrowedAt,
                mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<double> watchTotalActiveDebt() {
    return (_db.select(_db.debts)
          ..where((d) =>
              d.status.equals('active') |
              d.status.equals('partiallyPaid')))
        .watch()
        .map((debts) =>
            debts.fold<double>(0.0, (s, d) => s + d.remainingAmount));
  }

  // ── CREATE ──────────────────────────────

  /// Catat hutang baru:
  /// 1. Tambah saldo wallet (karena dapat uang dari orang lain)
  /// 2. Catat record hutang
  Future<void> createDebt({
    required String creditorName,
    String? creditorContact,
    required double amount,
    required int targetWalletId,
    String? purpose,
    DateTime? targetPaymentDate,
    String? note,
  }) async {
    await _db.transaction(() async {
      // 1. Tambah saldo wallet
      await _walletRepo.adjustBalance(targetWalletId, amount);

      // 2. Catat hutang
      await _db.into(_db.debts).insert(
            DebtsCompanion.insert(
              creditorName: creditorName,
              creditorContact: Value(creditorContact),
              originalAmount: amount,
              remainingAmount: amount,
              targetWalletId: targetWalletId,
              borrowedAt: DateTime.now(),
              targetPaymentDate: Value(targetPaymentDate),
              purpose: Value(purpose),
              note: Value(note),
            ),
          );
    });
  }

  // ── PAY ─────────────────────────────────

  /// Bayar hutang:
  /// 1. Kurangi saldo wallet
  /// 2. Update remaining amount
  /// 3. Update status
  Future<void> payDebt({
    required int debtId,
    required double payAmount,
    required int fromWalletId,
    String? note,
  }) async {
    await _db.transaction(() async {
      final debt = await (_db.select(_db.debts)
            ..where((d) => d.id.equals(debtId)))
          .getSingleOrNull();

      if (debt == null) throw Exception('Hutang tidak ditemukan');
      if (debt.status == 'settled') {
        throw Exception('Hutang sudah lunas');
      }
      if (payAmount > debt.remainingAmount) {
        throw Exception('Jumlah bayar melebihi sisa hutang');
      }

      // 1. Kurangi saldo wallet
      await _walletRepo.adjustBalance(fromWalletId, -payAmount);

      // 2. Update hutang
      final newRemaining = debt.remainingAmount - payAmount;
      final newStatus = newRemaining <= 0 ? 'settled' : 'partiallyPaid';

      await (_db.update(_db.debts)
            ..where((d) => d.id.equals(debtId)))
          .write(DebtsCompanion(
        remainingAmount: Value(newRemaining),
        status: Value(newStatus),
        settledAt:
            newRemaining <= 0 ? Value(DateTime.now()) : const Value.absent(),
      ));
    });
  }
}