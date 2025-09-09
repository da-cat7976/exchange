import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/logic/source.dart';
import 'package:exchange/service/open_exchange_rates/api.dart';
import 'package:exchange/service/open_exchange_rates/services.dart';
import 'package:exchange/utils/dio.dart';
import 'package:exchange/utils/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
CurrencyService currencyService(Ref ref) {
  final source = ref.watch(sourceControllerProvider);
  final dio = ref.watch(dioProvider);

  switch (source) {
    case RateSource.openExchangeRates:
      return OerCurrencyService(api: OpenExchangeRatesApi(dio, baseUrl: Env.openExchangeRatesApi));
  }
}

@riverpod
ExchangeRatesService exchangeRatesService(Ref ref) {
  final source = ref.watch(sourceControllerProvider);
  final dio = ref.watch(dioProvider);

  switch (source) {
    case RateSource.openExchangeRates:
      return OerRatesService(api: OpenExchangeRatesApi(dio, baseUrl: Env.openExchangeRatesApi));
  }
}
