// lib/repositories/transaction_repository.dart
import 'package:drift/drift.dart';
import '../core/database/app_database.dart';

class MonthlyData {
  final DateTime month;
  final double income;
  final double expense;

  const MonthlyData({
    required this.month,
    required this.income,
    required this.expense,
  });

  double get net => income - expense;
}

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  // ─────────────────────────────────────────
  // READ
  // ─────────────────────────────────────────

  Stream<List<Transaction>> watchAllTransactions() {
    return (_db.select(_db.transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<Transaction>> watchTransactionsByWallet(int walletId) {
    return (_db.select(_db.transactions)
          ..where((t) =>
              t.isDeleted.equals(false) &
              (t.sourceWalletId.equals(walletId) |
                  t.destinationWalletId.equals(walletId))))
        .watch();
  }

  /// Stream total expense bulan ini — REAKTIF
  /// Stream total expense bulan ini — exclude deleted & kasbon/piutang
  Stream<double> watchTotalExpenseThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return (_db.select(_db.transactions)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.type.equals('expense') &
              t.date.isBetweenValues(start, end) &
              // Exclude piutang dari hitungan expense biasa
              t.category.isNotIn([
                'receivableGiven',
                'internalDebtBorrow',
              ])))
        .watch()
        .map((txs) => txs.fold<double>(0.0, (sum, t) => sum + t.amount));
  }

  /// Stream total income bulan ini — REAKTIF
  Stream<double> watchTotalIncomeThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return (_db.select(_db.transactions)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.type.equals('income') &
              t.date.isBetweenValues(start, end) &
              // Exclude penerimaan kasbon/piutang dari income biasa
              t.category.isNotIn([
                'receivableCollection',
                'internalDebtRepayment',
              ])))
        .watch()
        .map((txs) => txs.fold<double>(0.0, (sum, t) => sum + t.amount));
  }

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (_db.select(_db.transactions)
          ..where((t) =>
              t.isDeleted.equals(false) & t.date.isBetweenValues(start, end))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<Transaction>> getThisMonthTransactions() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return getTransactionsByDateRange(start, end);
  }

  Future<double> getTotalExpenseThisMonth() async {
    final transactions = await getThisMonthTransactions();
    return transactions
        .where((t) => t.type == 'expense')
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<double> getTotalIncomeThisMonth() async {
    final transactions = await getThisMonthTransactions();
    return transactions
        .where((t) => t.type == 'income')
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  // ─────────────────────────────────────────
  // CREATE
  // ─────────────────────────────────────────

  Future<int> createTransaction(TransactionsCompanion transaction) {
    return _db.into(_db.transactions).insert(transaction);
  }

  // ─────────────────────────────────────────
  // UPDATE
  // ─────────────────────────────────────────

  // Future<bool> updateTransaction(TransactionsCompanion transaction) {
  //   return _db.update(_db.transactions).replace(transaction);
  // }

  Future<bool> updateTransaction(TransactionsCompanion transaction) async {
    final rowsAffected = await (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transaction.id.value)))
        .write(transaction);
    return rowsAffected > 0;
  }

  /// Ambil transaksi by ID
  Future<Transaction?> getTransactionById(int id) {
    return (_db.select(_db.transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // ─────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────

  Future<void> softDeleteTransaction(int id) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id)))
        .write(const TransactionsCompanion(
      isDeleted: Value(true),
    ));
  }

  // ─────────────────────────────────────────
  // ANALYTICS
  // ─────────────────────────────────────────

  /// Transaksi bulan lalu
  Future<List<Transaction>> getLastMonthTransactions() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, 1);
    final end = DateTime(now.year, now.month, 0, 23, 59, 59);
    return getTransactionsByDateRange(start, end);
  }

  /// Total expense bulan lalu
  Future<double> getTotalExpenseLastMonth() async {
    final transactions = await getLastMonthTransactions();
    return transactions
        .where((t) => t.type == 'expense')
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  /// Expense per kategori bulan ini
  Future<Map<String, double>> getExpenseByCategory() async {
    final transactions = await getThisMonthTransactions();
    final Map<String, double> result = {};
    for (final tx in transactions.where((t) => t.type == 'expense')) {
      result[tx.category] = (result[tx.category] ?? 0) + tx.amount;
    }
    return result;
  }

  /// Data 6 bulan terakhir untuk chart tren
  Future<List<MonthlyData>> getLast6MonthsData() async {
    final now = DateTime.now();
    final List<MonthlyData> result = [];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
      final txs = await getTransactionsByDateRange(start, end);

      final income = txs
          .where((t) => t.type == 'income')
          .fold<double>(0.0, (s, t) => s + t.amount);
      final expense = txs
          .where((t) => t.type == 'expense')
          .fold<double>(0.0, (s, t) => s + t.amount);

      result.add(MonthlyData(
        month: month,
        income: income,
        expense: expense,
      ));
    }
    return result;
  }
}
