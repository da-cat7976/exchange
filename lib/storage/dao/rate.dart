import 'package:drift/drift.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/storage/dao/currency.dart';
import 'package:exchange/storage/db.dart';
import 'package:exchange/storage/tables.dart';

part 'rate.g.dart';

@DriftAccessor(tables: [Rates, Currencies])
class RateDao extends DatabaseAccessor<AppDatabase>
    with _$RateDaoMixin
    implements ExchangeRatesRepo {
  RateDao(super.attachedDatabase);

  @override
  Future<ExchangeRates?> get({
    required RateSource source,
    required String baseCode,
  }) async {
    const converter = CurrencyInfoConverter();

    final base = await _getCurrency(source, baseCode);
    if (base == null) return null;

    final q = select(rates).join([
      innerJoin(
        currencies,
        currencies.code.equalsExp(rates.currency) &
            currencies.source.equals(source.name),
      ),
    ]);

    q
      ..where(rates.source.equals(source.name) & rates.base.equals(baseCode))
      ..orderBy([OrderingTerm.asc(rates.currency)]);

    final info = await q
        .map(
          (r) => ExchangeInfo(
            currency: converter.fromRecord(r.readTable(currencies)),
            rate: r.read(rates.rate) ?? 0,
          ),
        )
        .get();

    return ExchangeRates(
      base: converter.fromRecord(base),
      rates: {for (final i in info) i.currency: i.rate},
    );
  }

  @override
  Future<void> save(ExchangeRates exchangeRates) async {
    final base = exchangeRates.base.code;
    final records = exchangeRates.rates.entries.map(
      (e) => RateRecord(
        base: base,
        source: e.key.source,
        currency: e.key.code,
        rate: e.value,
        // TODO: get updatedAt from response
        updatedAt: DateTime.now(),
      ),
    );

    await batch((b) => b.insertAllOnConflictUpdate(rates, records));
  }

  Future<CurrencyRecord?> _getCurrency(
    RateSource source,
    String baseCode,
  ) async {
    final q = select(currencies)
      ..where((t) => t.code.equals(baseCode) & t.source.equals(source.name));

    return q.getSingleOrNull();
  }
}
