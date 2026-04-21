// lib/providers/debt_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/app_database.dart';
import '../repositories/debt_repository.dart';
import 'database_provider.dart';
import 'wallet_provider.dart';

final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  return DebtRepository(
    ref.watch(databaseProvider),
    ref.watch(walletRepositoryProvider),
  );
});

final activeMyDebtsProvider = StreamProvider<List<Debt>>((ref) {
  return ref.watch(debtRepositoryProvider).watchActiveDebts();
});

final allMyDebtsProvider = StreamProvider<List<Debt>>((ref) {
  return ref.watch(debtRepositoryProvider).watchAllDebts();
});

final totalMyDebtProvider = StreamProvider<double>((ref) {
  return ref.watch(debtRepositoryProvider).watchTotalActiveDebt();
});

// ── NOTIFIER ────────────────────────────────

class DebtNotifier extends StateNotifier<AsyncValue<void>> {
  final DebtRepository _repo;

  DebtNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createDebt({
    required String creditorName,
    String? creditorContact,
    required double amount,
    required int targetWalletId,
    String? purpose,
    DateTime? targetPaymentDate,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.createDebt(
          creditorName: creditorName,
          creditorContact: creditorContact,
          amount: amount,
          targetWalletId: targetWalletId,
          purpose: purpose,
          targetPaymentDate: targetPaymentDate,
          note: note,
        ));
  }

  Future<void> payDebt({
    required int debtId,
    required double payAmount,
    required int fromWalletId,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.payDebt(
          debtId: debtId,
          payAmount: payAmount,
          fromWalletId: fromWalletId,
          note: note,
        ));
  }
}

final debtNotifierProvider =
    StateNotifierProvider<DebtNotifier, AsyncValue<void>>((ref) {
  return DebtNotifier(ref.watch(debtRepositoryProvider));
});