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
  late final base = text()();

  late final source = textEnum<RateSource>()();

  late final TextColumn currency = text()();

  late final RealColumn rate = real().check(rate.isBiggerThanValue(0))();

  late final updatedAt = dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {base, source, currency};

  @override
  List<String> get customConstraints => [
    'CONSTRAINT fk_base FOREIGN KEY (source, base) REFERENCES currencies (source, code)',
    'CONSTRAINT fk_currency FOREIGN KEY (source, currency) REFERENCES currencies (source, code)',
  ];
}

@TableIndex(name: 'idx_history_issued', columns: {#issuedAt})
@DataClassName('HistoryEntryRecord')
class HistoryEntries extends Table {
  late final id = integer().autoIncrement()();

  late final source = textEnum<RateSource>()();

  late final from = text()();

  late final to = text()();

  late final RealColumn fromAmount = real().nullable().check(
    fromAmount.isNull() | fromAmount.isBiggerThanValue(0),
  )();

  late final RealColumn toAmount = real().nullable().check(
    toAmount.isNull() | toAmount.isBiggerThanValue(0),
  )();

  late final RealColumn rate = real().check(rate.isBiggerThanValue(0))();

  late final issuedAt = dateTime()();

  @override
  List<String> get customConstraints => [
    'CONSTRAINT fk_from FOREIGN KEY (source, "from") REFERENCES currencies (source, code)',
    'CONSTRAINT fk_to FOREIGN KEY (source, "to") REFERENCES currencies (source, code)',
  ];
}
