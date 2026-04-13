// lib/models/wallet.dart
import 'package:drift/drift.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category =>
      text().withDefault(const Constant('personal'))();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('IDR'))();
  TextColumn get iconCode => text().nullable()();
  TextColumn get colorCode => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
}