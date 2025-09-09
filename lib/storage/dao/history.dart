import 'package:drift/drift.dart';
import 'package:exchange/domain/history.dart';
import 'package:exchange/storage/dao/currency.dart';
import 'package:exchange/storage/db.dart';
import 'package:exchange/storage/tables.dart';

part 'history.g.dart';

@DriftAccessor(tables: [Currencies, HistoryEntries])
class HistoryDao extends DatabaseAccessor<AppDatabase>
    with _$HistoryDaoMixin
    implements HistoryRepo {
  HistoryDao(super.attachedDatabase);

  @override
  Stream<List<HistoryEntry>> watch() {
    const converter = CurrencyInfoConverter();

    final from = alias(currencies, 'f');
    final to = alias(currencies, 't');

    final q = select(historyEntries).join([
      innerJoin(
        from,
        historyEntries.from.equalsExp(from.code) &
            historyEntries.source.equalsExp(from.source),
      ),
      innerJoin(
        to,
        historyEntries.to.equalsExp(to.code) &
            historyEntries.source.equalsExp(to.source),
      ),
    ]);

    q.orderBy([OrderingTerm.desc(historyEntries.issuedAt)]);

    HistoryEntry fromResult(TypedResult r) {
      final record = r.readTable(historyEntries);

      final fromAmount = record.fromAmount;
      if (fromAmount != null) {
        return FromHistoryEntry(
          source: record.source,
          from: converter.fromRecord(r.readTable(from)),
          to: converter.fromRecord(r.readTable(to)),
          rate: record.rate,
          issuedAt: record.issuedAt,
          fromAmount: fromAmount,
        );
      }

      return ToHistoryEntry(
        source: record.source,
        to: converter.fromRecord(r.readTable(to)),
        from: converter.fromRecord(r.readTable(from)),
        rate: record.rate,
        issuedAt: record.issuedAt,
        toAmount: record.toAmount!,
      );
    }

    return q.map(fromResult).watch();
  }

  @override
  Future<LastSettings?> getSettings() async {
    const converter = CurrencyInfoConverter();

    final from = alias(currencies, 'f');
    final to = alias(currencies, 't');

    final q = select(historyEntries).join([
      innerJoin(
        from,
        historyEntries.from.equalsExp(from.code) &
        historyEntries.source.equalsExp(from.source),
      ),
      innerJoin(
        to,
        historyEntries.to.equalsExp(to.code) &
        historyEntries.source.equalsExp(to.source),
      ),
    ]);

    q
      ..orderBy([OrderingTerm.desc(historyEntries.issuedAt)])
      ..limit(1);

    LastSettings fromResult(TypedResult r) {
      final record = r.readTable(historyEntries);

      return LastSettings(
        source: record.source,
        from: converter.fromRecord(r.readTable(from)),
        to: converter.fromRecord(r.readTable(to)),
      );
    }

    return q.map(fromResult).getSingleOrNull();
  }

  @override
  Future<void> save(HistoryEntry entry) async {
    final record = HistoryEntriesCompanion.insert(
      source: entry.source,
      from: entry.from.code,
      to: entry.to.code,
      rate: entry.rate,
      issuedAt: DateTime.now(),
    );

    await into(historyEntries).insert(record);
  }

  @override
  Future<void> clear() async {
    await delete(historyEntries).go();
  }
}
