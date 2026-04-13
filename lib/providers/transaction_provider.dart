// lib/providers/transaction_provider.dart
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/enums.dart';
import '../core/database/app_database.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/wallet_repository.dart';
import 'database_provider.dart';
import 'wallet_provider.dart';

// ─────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(ref.watch(databaseProvider));
});

// ─────────────────────────────────────────────
// STREAM PROVIDERS
// ─────────────────────────────────────────────

final allTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAllTransactions();
});

/// Stream transaksi berdasarkan wallet tertentu
final transactionsByWalletProvider =
    StreamProvider.family<List<Transaction>, int>((ref, walletId) {
  return ref
      .watch(transactionRepositoryProvider)
      .watchTransactionsByWallet(walletId);
});

// ─────────────────────────────────────────────
// FUTURE PROVIDERS
// ─────────────────────────────────────────────

final totalExpenseThisMonthProvider = StreamProvider<double>((ref) {
  return ref.watch(transactionRepositoryProvider).watchTotalExpenseThisMonth();
});

final totalIncomeThisMonthProvider = StreamProvider<double>((ref) {
  return ref.watch(transactionRepositoryProvider).watchTotalIncomeThisMonth();
});

// ─────────────────────────────────────────────
// NOTIFIER — untuk operasi CRUD transaksi
// ─────────────────────────────────────────────

class TransactionNotifier extends StateNotifier<AsyncValue<void>> {
  final TransactionRepository _txRepo;
  final WalletRepository _walletRepo;

  TransactionNotifier(this._txRepo, this._walletRepo)
      : super(const AsyncValue.data(null));

  /// Catat pengeluaran biasa
  Future<void> addExpense({
    required String uuid,
    required String description,
    required double amount,
    required int sourceWalletId,
    required TransactionCategory category,
    required DateTime date,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Kurangi saldo wallet sumber
      await _walletRepo.adjustBalance(sourceWalletId, -amount);

      // 2. Catat transaksi
      await _txRepo.createTransaction(
        TransactionsCompanion.insert(
          uuid: uuid,
          type: TransactionType.expense.name,
          category: category.name,
          amount: amount,
          description: description,
          date: date,
          sourceWalletId: Value(sourceWalletId),
          note: Value(note),
        ),
      );
    });
  }

  /// Catat pemasukan biasa
  Future<void> addIncome({
    required String uuid,
    required String description,
    required double amount,
    required int targetWalletId,
    required TransactionCategory category,
    required DateTime date,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Tambah saldo wallet tujuan
      await _walletRepo.adjustBalance(targetWalletId, amount);

      // 2. Catat transaksi
      await _txRepo.createTransaction(
        TransactionsCompanion.insert(
          uuid: uuid,
          type: TransactionType.income.name,
          category: category.name,
          amount: amount,
          description: description,
          date: date,
          sourceWalletId: Value(targetWalletId),
          note: Value(note),
        ),
      );
    });
  }

  /// Transfer antar wallet biasa (bukan kasbon)
  Future<void> addTransfer({
    required String uuid,
    required String description,
    required double amount,
    required int sourceWalletId,
    required int destinationWalletId,
    required DateTime date,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _walletRepo.adjustBalance(sourceWalletId, -amount);
      await _walletRepo.adjustBalance(destinationWalletId, amount);

      await _txRepo.createTransaction(
        TransactionsCompanion.insert(
          uuid: uuid,
          type: TransactionType.transfer.name,
          category: TransactionCategory.other.name,
          amount: amount,
          description: description,
          date: date,
          sourceWalletId: Value(sourceWalletId),
          destinationWalletId: Value(destinationWalletId),
          note: Value(note),
        ),
      );
    });
  }

  /// Edit transaksi:
  /// 1. Reverse efek transaksi lama ke saldo wallet
  /// 2. Apply efek transaksi baru ke saldo wallet
  /// 3. Update record transaksi
  Future<void> editTransaction({
    required int transactionId,
    required String description,
    required double newAmount,
    required int newSourceWalletId,
    required TransactionCategory newCategory,
    required DateTime newDate,
    int? newDestinationWalletId,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Ambil transaksi lama
      final oldTx = await _txRepo.getTransactionById(transactionId);
      if (oldTx == null) throw Exception('Transaksi tidak ditemukan');

      // 2. Reverse efek lama
      switch (oldTx.type) {
        case 'expense':
          // Kembalikan saldo yang sudah dikurangi
          await _walletRepo.adjustBalance(
            oldTx.sourceWalletId!,
            oldTx.amount,
          );
        case 'income':
          // Kurangi saldo yang sudah ditambah
          await _walletRepo.adjustBalance(
            oldTx.sourceWalletId!,
            -oldTx.amount,
          );
        case 'transfer':
          if (oldTx.sourceWalletId != null) {
            await _walletRepo.adjustBalance(
              oldTx.sourceWalletId!,
              oldTx.amount,
            );
          }
          if (oldTx.destinationWalletId != null) {
            await _walletRepo.adjustBalance(
              oldTx.destinationWalletId!,
              -oldTx.amount,
            );
          }
      }

      // 3. Apply efek baru
      switch (oldTx.type) {
        case 'expense':
          await _walletRepo.adjustBalance(
            newSourceWalletId,
            -newAmount,
          );
        case 'income':
          await _walletRepo.adjustBalance(
            newSourceWalletId,
            newAmount,
          );
        case 'transfer':
          await _walletRepo.adjustBalance(
            newSourceWalletId,
            -newAmount,
          );
          if (newDestinationWalletId != null) {
            await _walletRepo.adjustBalance(
              newDestinationWalletId,
              newAmount,
            );
          }
      }

      // 4. Update record transaksi
      await _txRepo.updateTransaction(
        TransactionsCompanion(
          id: Value(transactionId),
          description: Value(description),
          amount: Value(newAmount),
          category: Value(newCategory.name),
          date: Value(newDate),
          sourceWalletId: Value(newSourceWalletId),
          destinationWalletId: Value(newDestinationWalletId),
          note: Value(note),
        ),
      );
    });
  }

  Future<void> deleteTransaction(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _txRepo.softDeleteTransaction(id),
    );
  }
}

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<void>>((ref) {
  return TransactionNotifier(
    ref.watch(transactionRepositoryProvider),
    ref.watch(walletRepositoryProvider),
  );
});

final totalExpenseLastMonthProvider = FutureProvider<double>((ref) {
  return ref.watch(transactionRepositoryProvider).getTotalExpenseLastMonth();
});

final expenseByCategoryProvider = FutureProvider<Map<String, double>>((ref) {
  return ref.watch(transactionRepositoryProvider).getExpenseByCategory();
});

final last6MonthsDataProvider = FutureProvider<List<MonthlyData>>((ref) {
  return ref.watch(transactionRepositoryProvider).getLast6MonthsData();
});


/// State untuk filter transaksi
class TransactionFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? type; // income/expense/transfer/null=semua
  final String? category;

  const TransactionFilter({
    this.startDate,
    this.endDate,
    this.type,
    this.category,
  });

  bool get isActive =>
      startDate != null || endDate != null ||
      type != null || category != null;

  TransactionFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? category,
    bool clearType = false,
    bool clearCategory = false,
    bool clearDates = false,
  }) {
    return TransactionFilter(
      startDate: clearDates ? null : startDate ?? this.startDate,
      endDate: clearDates ? null : endDate ?? this.endDate,
      type: clearType ? null : type ?? this.type,
      category: clearCategory ? null : category ?? this.category,
    );
  }
}

final transactionFilterProvider =
    StateProvider<TransactionFilter>((ref) => const TransactionFilter());

/// Stream transaksi yang sudah difilter
final filteredTransactionsProvider =
    StreamProvider<List<Transaction>>((ref) {
  final filter = ref.watch(transactionFilterProvider);
  final allTxStream = ref
      .watch(transactionRepositoryProvider)
      .watchAllTransactions();

  return allTxStream.map((txs) {
    var filtered = txs;

    if (filter.type != null) {
      filtered =
          filtered.where((t) => t.type == filter.type).toList();
    }
    if (filter.category != null) {
      filtered = filtered
          .where((t) => t.category == filter.category)
          .toList();
    }
    if (filter.startDate != null) {
      filtered = filtered
          .where((t) => !t.date.isBefore(filter.startDate!))
          .toList();
    }
    if (filter.endDate != null) {
      filtered = filtered
          .where((t) => !t.date.isAfter(filter.endDate!))
          .toList();
    }
    return filtered;
  });
});