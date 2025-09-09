import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/source.dart';

part 'rate.g.dart';

@CopyWith()
final class ExchangeRates with EquatableMixin {
  final CurrencyInfo base;

  const ExchangeRates({required this.base});

  @override
  List<Object?> get props => [base];

  ExchangeRates mergeNames(Iterable<CurrencyInfo> fullInfo) {
    throw UnimplementedError();
  }
}

@CopyWith()
class ExchangeInfo with EquatableMixin {
  final CurrencyInfo currency;

  final double rate;

  const ExchangeInfo({required this.currency, required this.rate});

  @override
  List<Object?> get props => [currency, rate];
}

abstract interface class ExchangeRatesService {
  Future<ExchangeRates> getRates();
}

abstract interface class ExchangeRatesRepo {
  Future<ExchangeRates?> get({
    required RateSource source,
    required String baseCode,
  });

  Future<void> save(ExchangeRates exchangeRates);
}
