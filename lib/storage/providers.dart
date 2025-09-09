import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/history.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/storage/dao/currency.dart';
import 'package:exchange/storage/dao/history.dart';
import 'package:exchange/storage/dao/rate.dart';
import 'package:exchange/storage/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
CurrencyRepo currencyRepo(Ref ref) {
  return CurrencyDao(ref.watch(dbProvider));
}

@riverpod
ExchangeRatesRepo rateRepo(Ref ref) {
  return RateDao(ref.watch(dbProvider));
}

@riverpod
HistoryRepo historyRepo(Ref ref) {
  return HistoryDao(ref.watch(dbProvider));
}
