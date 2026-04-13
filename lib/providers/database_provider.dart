// lib/providers/database_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/app_database.dart';

/// Single instance database — keepAlive agar tidak di-dispose
final databaseProvider = Provider<AppDatabase>(
  (ref) {
    final db = AppDatabase();
    ref.onDispose(db.close);
    return db;
  },
  // keepAlive by default di Provider biasa (bukan autoDispose)
);