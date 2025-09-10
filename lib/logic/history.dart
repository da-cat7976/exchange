import 'package:exchange/domain/history.dart';
import 'package:exchange/logic/exchange.dart';
import 'package:exchange/storage/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history.g.dart';

@riverpod
Stream<List<HistoryEntry>> history(Ref ref) {
  final historyRepo = ref.watch(historyRepoProvider);
  return historyRepo.watch();
}

@riverpod
class HistoryController extends _$HistoryController {
  @override
  Future<void> build() async {
    _repo = ref.watch(historyRepoProvider);
  }

  late HistoryRepo _repo;

  Future<void> commitCurrent() async {
    final settings = ref
        .read(exchangeSettingsControllerProvider)
        .valueOrNull
        ?.asReady();
    final amount = ref.read(exchangedAmountProvider).valueOrNull;
    if (settings == null || amount == null) return;

    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final entry = settings.toHistoryEntry(amount.rate);
      await _repo.save(entry);
    });
  }

  Future<void> clear() async {
    state = AsyncLoading();
    state = await AsyncValue.guard(_repo.clear);
  }
}

extension on ReadyExchangeSettingsState {
  HistoryEntry toHistoryEntry(double rate) {
    switch (direction) {
      case ExchangeDirection.fromTo:
        return FromHistoryEntry(
          source: from.source,
          from: from,
          to: to,
          fromAmount: amount,
          rate: rate,
          issuedAt: DateTime.now(),
        );

      case ExchangeDirection.toFrom:
        return ToHistoryEntry(
          source: from.source,
          to: to,
          from: from,
          toAmount: amount,
          rate: rate,
          issuedAt: DateTime.now(),
        );
    }
  }
}
