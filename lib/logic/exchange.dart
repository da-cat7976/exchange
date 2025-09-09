import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exchange.g.dart';

sealed class ExchangeState with EquatableMixin {
  final RateSource source;

  const ExchangeState({required this.source});
}

@CopyWith()
final class IdleExchangeState extends ExchangeState {
  final CurrencyInfo? from;

  final CurrencyInfo? to;

  IdleExchangeState({required super.source, this.from, this.to});

  @override
  List<Object?> get props => [source, from, to];
}

abstract class ReadyExchangeState extends ExchangeState {
  final double amount;

  final double converted;

  ReadyExchangeState({
    required super.source,
    required this.amount,
    required this.converted,
  });

  @override
  List<Object?> get props => [source, amount, converted];
}

@CopyWith()
final class FromExchangeState extends ReadyExchangeState {
  FromExchangeState({
    required super.source,
    required super.amount,
    required super.converted,
  });
}

@CopyWith()
final class ToExchangeState extends ReadyExchangeState {
  ToExchangeState({
    required super.source,
    required super.amount,
    required super.converted,
  });
}

@riverpod
class ExchangeController extends _$ExchangeController {
  @override
  Future<ExchangeState> build() {
    // TODO: implement
    throw UnimplementedError();
  }
}
