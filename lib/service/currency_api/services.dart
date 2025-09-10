import 'package:dio/dio.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/service/currency_api/api.dart';
import 'package:exchange/utils/env.dart';

final class CurrencyApiCurrencyService implements CurrencyService {
  CurrencyApiCurrencyService(Dio dio)
    : api = CurrencyApiApi(dio, baseUrl: Env.currencyApiUrl);

  final CurrencyApiApi api;

  @override
  Future<List<CurrencyInfo>> getAvailableCurrencies() async {
    final response = await api.getCurrencies();
    return response.entries
        .map(
          (e) => CurrencyInfo(
            code: e.key,
            name: e.value,
            source: RateSource.currencyApi,
          ),
        )
        .toList();
  }
}

final class CurrencyApiRateService implements ExchangeRatesService {
  CurrencyApiRateService(Dio dio)
    : api = CurrencyApiApi(dio, baseUrl: Env.currencyApiUrl);

  final CurrencyApiApi api;

  @override
  Future<ExchangeRates> getRates() async {
    final response = await api.getRates();
    return ExchangeRates(
      base: CurrencyInfo(
        code: RateSource.currencyApi.baseCurrencyCode,
        source: RateSource.currencyApi,
      ),
      rates: response.usd.map(
        (code, rate) => MapEntry(
          CurrencyInfo(code: code, source: RateSource.currencyApi),
          rate,
        ),
      ),
    );
  }
}
