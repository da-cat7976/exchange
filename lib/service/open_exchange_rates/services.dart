import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/service/open_exchange_rates/api.dart';

final class OerCurrencyService implements CurrencyService {
  final OpenExchangeRatesApi api;

  const OerCurrencyService({required this.api});

  @override
  Future<List<CurrencyInfo>> getAvailableCurrencies() async {
    final response = await api.getCurrencies();

    return response.entries
        .map(
          (e) => CurrencyInfo(
            code: e.key,
            name: e.value,
            source: RateSource.openExchangeRates,
          ),
        )
        .toList();
  }
}

final class OerRatesService implements ExchangeRatesService {
  final OpenExchangeRatesApi api;

  const OerRatesService({required this.api});

  @override
  Future<ExchangeRates> getRates() async {
    final response = await api.getRates();

    return ExchangeRates(
      base: CurrencyInfo(
        code: response.base,
        source: RateSource.openExchangeRates,
      ),
      rates: response.rates.map(
        (code, rate) => MapEntry(
          CurrencyInfo(code: code, source: RateSource.openExchangeRates),
          rate,
        ),
      ),
    );
  }
}
