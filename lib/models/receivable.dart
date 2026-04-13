// lib/models/receivable.dart
import 'package:drift/drift.dart';
import 'wallet.dart';

class Receivables extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get borrowerName => text()();
  TextColumn get borrowerContact => text().nullable()();
  RealColumn get originalAmount => real()();
  RealColumn get remainingAmount => real()();
  TextColumn get status =>
      text().withDefault(const Constant('active'))();
  IntColumn get sourceWalletId =>
      integer().references(Wallets, #id)();
  DateTimeColumn get lentAt => dateTime()();
  DateTimeColumn get targetReturnDate => dateTime().nullable()();
  DateTimeColumn get collectedAt => dateTime().nullable()();
  TextColumn get purpose => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}