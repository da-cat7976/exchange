import 'package:drift/drift.dart';
import 'package:exchange/domain/source.dart';

@TableIndex(name: 'idx_currencies_invalidated', columns: {#invalidated})
@DataClassName('CurrencyRecord')
class Currencies extends Table {
  late final code = text()();

  late final name = text()();

  late final source = textEnum<RateSource>()();

  late final invalidated = boolean().withDefault(Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {code, source};
}

@DataClassName('RateRecord')
class Rates extends Table {
  @ReferenceName('base')
  late final base = text().references(Currencies, #code)();

  late final source = textEnum<RateSource>()();

  @ReferenceName('currency')
  late final TextColumn currency = text()
      .references(Currencies, #code)
      .check(base.equalsExp(currency).not())();

  late final RealColumn rate = real().check(rate.isBiggerThanValue(0))();

  late final updatedAt = dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {base, source, currency};
}

@TableIndex(name: 'idx_history_issued', columns: {#issuedAt})
@DataClassName('HistoryEntryRecord')
class HistoryEntries extends Table {
  late final id = integer().autoIncrement()();

  late final source = textEnum<RateSource>()();

  @ReferenceName('from')
  late final from = text().references(Currencies, #code)();

  @ReferenceName('to')
  late final to = text().references(Currencies, #code)();

  late final RealColumn fromAmount = real().nullable().check(
    fromAmount.isNull() | fromAmount.isBiggerThanValue(0),
  )();

  late final RealColumn toAmount = real().nullable().check(
    toAmount.isNull() | toAmount.isBiggerThanValue(0),
  )();

  late final RealColumn rate = real().check(rate.isBiggerThanValue(0))();

  late final issuedAt = dateTime()();
}
