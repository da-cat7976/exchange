import 'package:exchange/domain/trend.dart';
import 'package:exchange/logic/exchange.dart';
import 'package:exchange/service/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trends.g.dart';

// ? Keeping this provider alive since trend fetching is time greedy
@Riverpod(keepAlive: true)
Future<RateTrend?> trends(Ref ref) {
  final service = ref.watch(rateTrendServiceProvider);
  return service.getTrend();
}

@riverpod
Future<Map<DateTime, double>> trendForCurrent(Ref ref) async {
  final settings = await ref.watch(exchangeSettingsControllerProvider.future);

  final trend = await ref.watch(trendsProvider.future);

  final from = settings.from;
  final to = settings.to;
  if (from == null || to == null || trend == null) return {};

  return trend.getForPair(from: from, to: to);
}
