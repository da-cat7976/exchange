import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/currency.dart';

part 'history.g.dart';

sealed class HistoryEntry with EquatableMixin {
  final CurrencyInfo from;

  final CurrencyInfo to;

  final double rate;

  final DateTime issuedAt;

  const HistoryEntry({
    required this.from,
    required this.to,
    required this.rate,
    required this.issuedAt,
  });

  @override
  List<Object?> get props => [from, to, rate, issuedAt];
}

@CopyWith()
final class FromHistoryEntry extends HistoryEntry with EquatableMixin {
  final double fromAmount;

  FromHistoryEntry({
    required super.from,
    required super.to,
    required super.rate,
    required super.issuedAt,
    required this.fromAmount,
  });

  @override
  List<Object?> get props => [from, to, rate, issuedAt, fromAmount];
}

@CopyWith()
final class ToHistoryEntry extends HistoryEntry with EquatableMixin {
  final double toAmount;

  ToHistoryEntry({
    required super.from,
    required super.to,
    required super.rate,
    required super.issuedAt,
    required this.toAmount,
  });

  @override
  List<Object?> get props => [from, to, rate, issuedAt, toAmount];
}

abstract interface class HistoryRepo {
  Future<List<HistoryEntry>> list();

  Future<void> save(HistoryEntry entry);

  Future<void> clear();
}
