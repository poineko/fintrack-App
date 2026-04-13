// lib/models/transaction.dart
import 'package:drift/drift.dart';
import 'wallet.dart';
import 'internal_debt.dart';
import 'receivable.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().withLength(min: 36, max: 36)();
  TextColumn get type => text()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get receiptImagePath => text().nullable()();

  /// Sumber dana
  @ReferenceName('transactionsAsSource')
  IntColumn get sourceWalletId =>
      integer().nullable().references(Wallets, #id)();

  /// Tujuan dana (untuk transfer)
  @ReferenceName('transactionsAsDestination')
  IntColumn get destinationWalletId =>
      integer().nullable().references(Wallets, #id)();

  @ReferenceName('transactionsForDebt')
  IntColumn get relatedInternalDebtId =>
      integer().nullable().references(InternalDebts, #id)();

  @ReferenceName('transactionsForReceivable')
  IntColumn get relatedReceivableId =>
      integer().nullable().references(Receivables, #id)();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false))();
}