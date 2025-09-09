import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/source.dart';

part 'history.g.dart';

sealed class HistoryEntry with EquatableMixin {
  final RateSource source;

  final CurrencyInfo from;

  final CurrencyInfo to;

  final double rate;

  final DateTime issuedAt;

  const HistoryEntry({
    required this.source,
    required this.from,
    required this.to,
    required this.rate,
    required this.issuedAt,
  });

  double get exchanged;

  @override
  List<Object?> get props => [source, from, to, rate, issuedAt];
}

@CopyWith()
final class FromHistoryEntry extends HistoryEntry with EquatableMixin {
  final double fromAmount;

  FromHistoryEntry({
    required super.source,
    required super.from,
    required super.to,
    required super.rate,
    required super.issuedAt,
    required this.fromAmount,
  });

  @override
  double get exchanged => fromAmount * rate;

  @override
  List<Object?> get props => [...super.props, fromAmount];
}

@CopyWith()
final class ToHistoryEntry extends HistoryEntry with EquatableMixin {
  final double toAmount;

  ToHistoryEntry({
    required super.source,
    required super.from,
    required super.to,
    required super.rate,
    required super.issuedAt,
    required this.toAmount,
  });

  @override
  double get exchanged => toAmount / rate;

  @override
  List<Object?> get props => [...super.props, toAmount];
}

class LastSettings {
  final RateSource source;

  final CurrencyInfo from;

  final CurrencyInfo to;

  const LastSettings({
    required this.source,
    required this.from,
    required this.to,
  });
}

abstract interface class HistoryRepo {
  Stream<List<HistoryEntry>> watch();

  Future<LastSettings?> getSettings();

  Future<void> save(HistoryEntry entry);

  Future<void> clear();
}
