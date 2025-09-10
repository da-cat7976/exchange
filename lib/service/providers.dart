import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/domain/trend.dart';
import 'package:exchange/logic/source.dart';
import 'package:exchange/service/currency_api/services.dart';
import 'package:exchange/service/open_exchange_rates/services.dart';
import 'package:exchange/utils/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
CurrencyService currencyService(Ref ref) {
  final source = ref.watch(sourceControllerProvider);
  final dio = ref.watch(dioProvider);

  switch (source) {
    case RateSource.openExchangeRates:
      return OerCurrencyService(dio);

    case RateSource.currencyApi:
      return CurrencyApiCurrencyService(dio);
  }
}

@riverpod
ExchangeRatesService exchangeRatesService(Ref ref) {
  final source = ref.watch(sourceControllerProvider);
  final dio = ref.watch(dioProvider);

  switch (source) {
    case RateSource.openExchangeRates:
      return OerRatesService(dio);

    case RateSource.currencyApi:
      return CurrencyApiRateService(dio);
  }
}

@riverpod
RateTrendService rateTrendService(Ref ref) {
  final source = ref.watch(sourceControllerProvider);

  switch (source) {
    case RateSource.openExchangeRates:
      return RateTrendService();

    case RateSource.currencyApi:
      return CurrencyApiTrendService(DioFactory.instance.create());
  }
}
