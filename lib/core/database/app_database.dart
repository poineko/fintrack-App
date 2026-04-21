// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../../models/wallet.dart';
import '../../models/transaction.dart';
import '../../models/internal_debt.dart';
import '../../models/receivable.dart';
import '../../models/debt.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Wallets,
    InternalDebts, // Urutan penting! InternalDebts & Receivables
    Receivables, // harus sebelum Transactions (foreign key)
    Transactions,
    Debts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // ← Naikkan versi

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(debts);
        }
      },
      beforeOpen: (details) async {
        // Aktifkan foreign key enforcement
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'fintrack_db');
  }
}
