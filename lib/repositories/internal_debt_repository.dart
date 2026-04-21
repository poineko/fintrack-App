// lib/repositories/internal_debt_repository.dart
import 'package:drift/drift.dart';
import '../core/constants/enums.dart';
import '../core/database/app_database.dart';
import 'wallet_repository.dart';

class InternalDebtRepository {
  final AppDatabase _db;
  final WalletRepository _walletRepo;

  InternalDebtRepository(this._db, this._walletRepo);

  // ─────────────────────────────────────────
  // READ
  // ─────────────────────────────────────────

  /// Stream semua kasbon aktif
  Stream<List<InternalDebt>> watchActiveDebts() {
    return (_db.select(_db.internalDebts)
          ..where((d) =>
              d.status.equals(InternalDebtStatus.active.name) |
              d.status.equals(InternalDebtStatus.partiallyPaid.name))
          ..orderBy([
            (d) =>
                OrderingTerm(expression: d.borrowedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Stream semua kasbon (termasuk lunas)
  Stream<List<InternalDebt>> watchAllDebts() {
    return (_db.select(_db.internalDebts)
          ..orderBy([
            (d) =>
                OrderingTerm(expression: d.borrowedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Stream total hutang aktif — REAKTIF
  Stream<double> watchTotalActiveDebt() {
    return (_db.select(_db.internalDebts)
          ..where((d) =>
              d.status.equals(InternalDebtStatus.active.name) |
              d.status.equals(InternalDebtStatus.partiallyPaid.name)))
        .watch()
        .map((debts) =>
            debts.fold<double>(0.0, (sum, d) => sum + d.remainingAmount));
  }

  Future<InternalDebt?> getDebtById(int id) {
    return (_db.select(_db.internalDebts)..where((d) => d.id.equals(id)))
        .getSingleOrNull();
  }

  /// Total hutang internal yang belum lunas
  Future<double> getTotalActiveDebt() async {
    final debts = await (_db.select(_db.internalDebts)
          ..where((d) =>
              d.status.equals(InternalDebtStatus.active.name) |
              d.status.equals(InternalDebtStatus.partiallyPaid.name)))
        .get();
    return debts.fold<double>(0.0, (sum, d) => sum + d.remainingAmount);
  }

  // ─────────────────────────────────────────
  // CREATE — ⭐ INTI LOGIKA KASBON
  // ─────────────────────────────────────────

  /// Buat kasbon baru:
  /// 1. Kurangi saldo sourceWallet (misal: Tabungan Bersama)
  /// 2. Tambah saldo destinationWallet (misal: Uang Pribadi)
  /// 3. Catat InternalDebt record
  /// 4. Catat Transaction record sebagai bukti
  Future<void> createKasbon({
    required String title,
    required double amount,
    required int sourceWalletId,
    required int destinationWalletId,
    required String uuid,
    DateTime? targetRepaymentDate,
    String? note,
  }) async {
    await _db.transaction(() async {
      // 1. Validasi wallet
      final sourceWallet = await _walletRepo.getWalletById(sourceWalletId);
      final destWallet = await _walletRepo.getWalletById(destinationWalletId);

      if (sourceWallet == null) {
        throw Exception('Source wallet tidak ditemukan');
      }

      if (destWallet == null) {
        throw Exception('Destination wallet tidak ditemukan');
      }
      if (sourceWallet.balance < amount) {
        throw Exception(
            'Saldo ${sourceWallet.name} tidak cukup (${sourceWallet.balance} < $amount)');
      }

      // 2. Kurangi saldo source wallet
      await _walletRepo.adjustBalance(sourceWalletId, -amount);

      // 3. Tambah saldo destination wallet
      await _walletRepo.adjustBalance(destinationWalletId, amount);

      // 4. Buat record InternalDebt
      final debtId = await _db.into(_db.internalDebts).insert(
            InternalDebtsCompanion.insert(
              title: title,
              originalAmount: amount,
              remainingAmount: amount,
              status: const Value('active'),
              sourceWalletId: sourceWalletId,
              destinationWalletId: destinationWalletId,
              borrowedAt: DateTime.now(),
              targetRepaymentDate: Value(targetRepaymentDate),
              note: Value(note),
            ),
          );

      // 5. Catat sebagai Transaction
      await _db.into(_db.transactions).insert(
            TransactionsCompanion.insert(
              uuid: uuid,
              type: 'transfer',
              category: TransactionCategory.internalDebtBorrow.name,
              amount: amount,
              description: 'Kasbon: $title',
              date: DateTime.now(),
              sourceWalletId: Value(sourceWalletId),
              destinationWalletId: Value(destinationWalletId),
              relatedInternalDebtId: Value(debtId),
              note: Value(note),
            ),
          );
    });
  }

  // ─────────────────────────────────────────
  // REPAYMENT — ⭐ LOGIKA PELUNASAN KASBON
  // ─────────────────────────────────────────

  /// Bayar/lunasi kasbon:
  /// 1. Kurangi saldo destinationWallet (uang dikembalikan dari sini)
  /// 2. Tambah saldo sourceWallet (dikembalikan ke sini)
  /// 3. Update remainingAmount di InternalDebt
  /// 4. Update status (partiallyPaid / settled)
  /// 5. Catat Transaction pelunasan
  Future<void> repayKasbon({
    required int debtId,
    required double repayAmount,
    required String uuid,
    String? note,
  }) async {
    await _db.transaction(() async {
      // 1. Ambil data kasbon
      final debt = await getDebtById(debtId);
      if (debt == null) throw Exception('Kasbon tidak ditemukan');
      // ✅ SESUDAH — dengan curly braces
      if (debt.status == InternalDebtStatus.settled.name) {
        throw Exception('Kasbon sudah lunas');
      }
      if (repayAmount > debt.remainingAmount) {
        throw Exception(
            'Jumlah bayar ($repayAmount) melebihi sisa kasbon (${debt.remainingAmount})');
      }

      // 2. Kurangi saldo destination wallet (yang pakai uang kasbon)
      await _walletRepo.adjustBalance(debt.destinationWalletId, -repayAmount);

      // 3. Kembalikan ke source wallet
      await _walletRepo.adjustBalance(debt.sourceWalletId, repayAmount);

      // 4. Hitung sisa & update status
      final newRemaining = debt.remainingAmount - repayAmount;
      final newStatus = newRemaining <= 0
          ? InternalDebtStatus.settled.name
          : InternalDebtStatus.partiallyPaid.name;

      await (_db.update(_db.internalDebts)..where((d) => d.id.equals(debtId)))
          .write(InternalDebtsCompanion(
        remainingAmount: Value(newRemaining),
        status: Value(newStatus),
        settledAt:
            newRemaining <= 0 ? Value(DateTime.now()) : const Value.absent(),
      ));

      // 5. Catat Transaction pelunasan
      await _db.into(_db.transactions).insert(
            TransactionsCompanion.insert(
              uuid: uuid,
              type: 'transfer',
              category: TransactionCategory.internalDebtRepayment.name,
              amount: repayAmount,
              description: 'Bayar kasbon: ${debt.title}',
              date: DateTime.now(),
              sourceWalletId: Value(debt.destinationWalletId),
              destinationWalletId: Value(debt.sourceWalletId),
              relatedInternalDebtId: Value(debtId),
              note: Value(note),
            ),
          );
    });
  }
}
