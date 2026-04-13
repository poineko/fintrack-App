// lib/providers/internal_debt_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/app_database.dart';
import '../repositories/internal_debt_repository.dart';
import 'database_provider.dart';
import 'wallet_provider.dart';

// ─────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────

final internalDebtRepositoryProvider =
    Provider<InternalDebtRepository>((ref) {
  return InternalDebtRepository(
    ref.watch(databaseProvider),
    ref.watch(walletRepositoryProvider),
  );
});

// ─────────────────────────────────────────────
// STREAM PROVIDERS
// ─────────────────────────────────────────────

final activeDebtsProvider =
    StreamProvider<List<InternalDebt>>((ref) {
  return ref
      .watch(internalDebtRepositoryProvider)
      .watchActiveDebts();
});

final allDebtsProvider = StreamProvider<List<InternalDebt>>((ref) {
  return ref
      .watch(internalDebtRepositoryProvider)
      .watchAllDebts();
});

// ─────────────────────────────────────────────
// FUTURE PROVIDERS
// ─────────────────────────────────────────────

final totalActiveDebtProvider = StreamProvider<double>((ref) {
  return ref
      .watch(internalDebtRepositoryProvider)
      .watchTotalActiveDebt();
});

// ─────────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────────

class InternalDebtNotifier extends StateNotifier<AsyncValue<void>> {
  final InternalDebtRepository _repo;

  InternalDebtNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createKasbon({
    required String title,
    required double amount,
    required int sourceWalletId,
    required int destinationWalletId,
    required String uuid,
    DateTime? targetRepaymentDate,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.createKasbon(
          title: title,
          amount: amount,
          sourceWalletId: sourceWalletId,
          destinationWalletId: destinationWalletId,
          uuid: uuid,
          targetRepaymentDate: targetRepaymentDate,
          note: note,
        ));
  }

  Future<void> repayKasbon({
    required int debtId,
    required double repayAmount,
    required String uuid,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.repayKasbon(
          debtId: debtId,
          repayAmount: repayAmount,
          uuid: uuid,
          note: note,
        ));
  }
}

final internalDebtNotifierProvider =
    StateNotifierProvider<InternalDebtNotifier, AsyncValue<void>>((ref) {
  return InternalDebtNotifier(
    ref.watch(internalDebtRepositoryProvider),
  );
});