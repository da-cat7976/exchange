import 'package:drift/drift.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/storage/db.dart';
import 'package:exchange/storage/tables.dart';

part 'currency.g.dart';

@DriftAccessor(tables: [Currencies])
class CurrencyDao extends DatabaseAccessor<AppDatabase>
    with _$CurrencyDaoMixin
    implements CurrencyRepo {
  CurrencyDao(super.attachedDatabase);

  @override
  Future<List<CurrencyInfo>> listBy(
    RateSource source, {
    Iterable<String>? codes,
    bool includeInvalidated = false,
  }) {
    const converter = CurrencyInfoConverter();

    final q = select(currencies)..where((t) => t.source.equals(source.name));
    if (codes != null) {
      q.where((t) => t.code.isIn(codes));
    }

    if (!includeInvalidated) {
      q.where((t) => t.invalidated.equals(false));
    }

    q.orderBy([(t) => OrderingTerm.desc(t.code)]);
    return q.map(converter.fromRecord).get();
  }

  @override
  Future<void> invalidate({
    required RateSource source,
    Iterable<CurrencyInfo>? except,
  }) async {
    final exceptCodes = except?.map((e) => e.code).toList();

    final q = update(currencies)..where((t) => t.source.equals(source.name));
    if (exceptCodes != null) {
      q.where((t) => t.code.isNotIn(exceptCodes));
    }

    await q.write(CurrenciesCompanion(invalidated: Value(true)));
  }

  @override
  Future<void> saveAll(Iterable<CurrencyInfo> data) async {
    const converter = CurrencyInfoConverter();
    final records = data.map(converter.toRecord);

    await batch((batch) {
      batch.insertAll(currencies, records, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> clear() async {
    await delete(currencies).go();
  }
}

class CurrencyInfoConverter {
  const CurrencyInfoConverter();

  CurrencyRecord toRecord(CurrencyInfo info) {
    return CurrencyRecord(
      code: info.code,
      name: info.name,
      source: info.source,
      invalidated: false,
    );
  }

  CurrencyInfo fromRecord(CurrencyRecord record) {
    return CurrencyInfo(
      code: record.code,
      name: record.name,
      source: record.source,
    );
  }
}
