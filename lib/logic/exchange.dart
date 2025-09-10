import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/rate.dart';
import 'package:exchange/logic/currencies.dart';
import 'package:exchange/logic/rates.dart';
import 'package:exchange/storage/providers.dart';
import 'package:exchange/utils/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exchange.g.dart';

enum ExchangeDirection { fromTo, toFrom }

sealed class ExchangeSettingsState with EquatableMixin {
  const ExchangeSettingsState();

  CurrencyInfo? get from;

  CurrencyInfo? get to;

  double? get amount;

  ExchangeDirection? get direction;

  @override
  List<Object?> get props => [from, to, amount, direction];

  ReadyExchangeSettingsState? asReady() {
    final from = this.from;
    final to = this.to;
    final amount = this.amount;
    final direction = this.direction;

    if (from != null && to != null && amount != null && direction != null) {
      return ReadyExchangeSettingsState(
        from: from,
        to: to,
        amount: amount,
        direction: direction,
      );
    }

    return null;
  }
}

@CopyWith()
final class RawExchangeSettingsState extends ExchangeSettingsState {
  @override
  final CurrencyInfo? from;

  @override
  final CurrencyInfo? to;

  @override
  final double? amount;

  @override
  final ExchangeDirection? direction;

  const RawExchangeSettingsState({
    this.from,
    this.to,
    this.amount,
    this.direction,
  });
}

final class ReadyExchangeSettingsState extends ExchangeSettingsState {
  @override
  final CurrencyInfo from;

  @override
  final CurrencyInfo to;

  @override
  final double amount;

  @override
  final ExchangeDirection direction;

  const ReadyExchangeSettingsState({
    required this.from,
    required this.to,
    required this.amount,
    required this.direction,
  });
}

@riverpod
class ExchangeSettingsController extends _$ExchangeSettingsController {
  @override
  Future<RawExchangeSettingsState> build() async {
    final current = state.valueOrNull ?? RawExchangeSettingsState();
    final currencies = _currencies = ref
        .watch(currenciesControllerProvider)
        .valueOrNull;

    final historyRepo = ref.watch(historyRepoProvider);
    final settings = await historyRepo.getSettings();

    final from = current.from ?? settings?.from;
    final to = current.to ?? settings?.to;

    return current.copyWith(
      from:
          currencies?.presentOrNull(from) ??
          currencies?.getByCode(from?.code) ??
          currencies?.getByCode(Env.defaultFrom),
      to:
          currencies?.presentOrNull(to) ??
          currencies?.getByCode(to?.code) ??
          currencies?.getByCode(Env.defaultTo),
    );
  }

  List<CurrencyInfo>? _currencies;

  void setFrom(CurrencyInfo from) {
    final current = state.valueOrNull;
    if (current == null) return;

    final valid = _currencies?.presentOrNull(from);
    if (valid == null) return;

    state = AsyncData(current.copyWith(from: valid));
  }

  void setTo(CurrencyInfo to) {
    final current = state.valueOrNull;
    if (current == null) return;

    final valid = _currencies?.presentOrNull(to);
    if (valid == null) return;

    state = AsyncData(current.copyWith(to: valid));
  }

  void setAmount({
    required double? amount,
    required ExchangeDirection direction,
  }) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(amount: amount, direction: direction));
  }
}

@riverpod
Future<RateExchangedPair?> exchangedAmount(Ref ref) async {
  final settings = ref
      .watch(exchangeSettingsControllerProvider)
      .valueOrNull
      ?.asReady();
  if (settings == null) return null;

  final rates = await ref.watch(ratesControllerProvider.future);

  final RateExchangedPair pair;
  if (settings.direction == ExchangeDirection.fromTo) {
    pair = rates.convertFrom(
      from: settings.from,
      to: settings.to,
      amount: settings.amount,
    );
  } else {
    pair = rates.convertTo(
      from: settings.from,
      to: settings.to,
      amount: settings.amount,
    );
  }

  return pair;
}
