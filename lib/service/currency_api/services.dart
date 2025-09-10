import 'package:dio/dio.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/domain/trend.dart';
import 'package:exchange/service/currency_api/api.dart';
import 'package:exchange/service/currency_api/history_interceptor.dart';
import 'package:exchange/utils/env.dart';
import 'package:intl/intl.dart';

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
            code: e.key.toUpperCase(),
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
          CurrencyInfo(
            code: code.toUpperCase(),
            source: RateSource.currencyApi,
          ),
          rate,
        ),
      ),
    );
  }
}

final class CurrencyApiTrendService implements RateTrendService {
  CurrencyApiTrendService(Dio dio)
    : api = CurrencyApiApi(
        dio..interceptors.add(CurrencyApiHistoryInterceptor()),
        baseUrl: Env.currencyApiHistoryUrl,
      );

  final CurrencyApiApi api;

  @override
  Future<RateTrend?> getTrend() async {
    final rates = await _fetchRates().toList();
    return RateTrend(rates: Map.fromEntries(rates));
  }

  Stream<MapEntry<DateTime, ExchangeRates>> _fetchRates() async* {
    final formatter = DateFormat('yyyy-MM-dd');
    final now = DateTime.now().toUtc();

    for (int i = RateTrend.defaultTrendLength - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateString = formatter.format(date);

      final response = await api.getRates(date: dateString);
      yield MapEntry(
        date,
        ExchangeRates(
          base: CurrencyInfo(
            code: RateSource.currencyApi.baseCurrencyCode,
            source: RateSource.currencyApi,
          ),
          rates: response.usd.map(
            (code, rate) => MapEntry(
              CurrencyInfo(
                code: code.toUpperCase(),
                source: RateSource.currencyApi,
              ),
              rate,
            ),
          ),
        ),
      );
    }
  }
}
