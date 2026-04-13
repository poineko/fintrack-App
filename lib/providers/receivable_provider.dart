// lib/providers/receivable_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/app_database.dart';
import '../repositories/receivable_repository.dart';
import 'database_provider.dart';
import 'wallet_provider.dart';

// ─────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────

final receivableRepositoryProvider =
    Provider<ReceivableRepository>((ref) {
  return ReceivableRepository(
    ref.watch(databaseProvider),
    ref.watch(walletRepositoryProvider),
  );
});

// ─────────────────────────────────────────────
// STREAM PROVIDERS
// ─────────────────────────────────────────────

final activeReceivablesProvider =
    StreamProvider<List<Receivable>>((ref) {
  return ref
      .watch(receivableRepositoryProvider)
      .watchActiveReceivables();
});

final allReceivablesProvider =
    StreamProvider<List<Receivable>>((ref) {
  return ref
      .watch(receivableRepositoryProvider)
      .watchAllReceivables();
});

// ─────────────────────────────────────────────
// STREAM TOTAL — reaktif
// ─────────────────────────────────────────────

final totalActiveReceivablesProvider =
    StreamProvider<double>((ref) {
  return ref
      .watch(receivableRepositoryProvider)
      .watchTotalActiveReceivables();
});

// ─────────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────────

class ReceivableNotifier extends StateNotifier<AsyncValue<void>> {
  final ReceivableRepository _repo;

  ReceivableNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createReceivable({
    required String borrowerName,
    String? borrowerContact,
    required double amount,
    required int sourceWalletId,
    required String uuid,
    DateTime? targetReturnDate,
    String? purpose,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.createReceivable(
          borrowerName: borrowerName,
          borrowerContact: borrowerContact,
          amount: amount,
          sourceWalletId: sourceWalletId,
          uuid: uuid,
          targetReturnDate: targetReturnDate,
          purpose: purpose,
          note: note,
        ));
  }

  Future<void> collectReceivable({
    required int receivableId,
    required double collectAmount,
    required int targetWalletId,
    required String uuid,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.collectReceivable(
          receivableId: receivableId,
          collectAmount: collectAmount,
          targetWalletId: targetWalletId,
          uuid: uuid,
          note: note,
        ));
  }

  Future<void> writeOffReceivable(int receivableId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repo.writeOffReceivable(receivableId),
    );
  }
}

final receivableNotifierProvider =
    StateNotifierProvider<ReceivableNotifier, AsyncValue<void>>((ref) {
  return ReceivableNotifier(
    ref.watch(receivableRepositoryProvider),
  );
});