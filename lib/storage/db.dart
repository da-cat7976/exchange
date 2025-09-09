import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:exchange/domain/cache.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/storage/tables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db.g.dart';

@riverpod
CacheRepo cacheRepo(Ref ref) {
  return ref.watch(dbProvider);
}

@Riverpod(keepAlive: true)
AppDatabase db(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);

  return db;
}

@DriftDatabase(tables: [Currencies, Rates, HistoryEntries])
class AppDatabase extends _$AppDatabase implements CacheRepo {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onUpgrade: (m, from, to) async {
      final tables = m.database.allTables;
      for (final table in tables) {
        await m.deleteTable(table.actualTableName);
        await m.createTable(table);
      }
    },
  );

  @override
  Future<void> clear() async {
    await transaction(() async {
      await historyEntries.deleteAll();
      await rates.deleteAll();
      await currencies.deleteAll();
    });
  }
}
