// lib/models/debt.dart
import 'package:drift/drift.dart';
import 'wallet.dart';

/// Hutang kita ke orang lain
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Nama orang yang kita hutangi
  TextColumn get creditorName => text()();

  /// Kontak kreditor
  TextColumn get creditorContact => text().nullable()();

  /// Jumlah awal hutang
  RealColumn get originalAmount => real()();

  /// Sisa hutang
  RealColumn get remainingAmount => real()();

  /// active / partiallyPaid / settled
  TextColumn get status =>
      text().withDefault(const Constant('active'))();

  /// Hutang ini untuk keperluan apa
  TextColumn get purpose => text().nullable()();

  /// Dana masuk ke wallet mana saat berhutang
  IntColumn get targetWalletId =>
      integer().references(Wallets, #id)();

  DateTimeColumn get borrowedAt => dateTime()();
  DateTimeColumn get targetPaymentDate => dateTime().nullable()();
  DateTimeColumn get settledAt => dateTime().nullable()();

  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}