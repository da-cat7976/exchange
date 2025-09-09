import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/source.dart';

part 'currency.g.dart';

@CopyWith()
final class CurrencyInfo with EquatableMixin {
  final String code;

  final String name;

  final RateSource source;

  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.source,
  });

  @override
  List<Object?> get props => [code, name];
}

abstract interface class CurrencyService {
  Future<List<CurrencyInfo>> getAvailableCurrencies();
}

abstract interface class CurrencyRepo {
  Future<List<CurrencyInfo>> listBy(RateSource source);

  Future<void> save(Iterable<CurrencyInfo> currencies);
}
