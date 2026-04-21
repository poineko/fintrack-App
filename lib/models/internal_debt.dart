// lib/models/internal_debt.dart
import 'package:drift/drift.dart';
import 'wallet.dart';

class InternalDebts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  RealColumn get originalAmount => real()();
  RealColumn get remainingAmount => real()();
  TextColumn get status => text().withDefault(const Constant('active'))();

  /// Dana DIAMBIL DARI dompet ini
  @ReferenceName('internalDebtsAsSource')
  IntColumn get sourceWalletId => integer().references(Wallets, #id)();

  /// Dana MASUK KE dompet ini
  @ReferenceName('internalDebtsAsDestination')
  IntColumn get destinationWalletId => integer().references(Wallets, #id)();

  DateTimeColumn get borrowedAt => dateTime()();
  DateTimeColumn get targetRepaymentDate => dateTime().nullable()();
  DateTimeColumn get settledAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
