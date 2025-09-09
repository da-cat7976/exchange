import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/source.dart';

part 'rate.g.dart';

/// Key - currency, value - rate
typedef RateMap = Map<CurrencyInfo, double>;

typedef RateExchangedPair = ({double rate, double exchanged});

@CopyWith()
final class ExchangeRates with EquatableMixin {
  final CurrencyInfo base;

  final RateMap rates;

  const ExchangeRates({required this.base, required this.rates});

  @override
  List<Object?> get props => [base];

  ExchangeRates mergeNames(Iterable<CurrencyInfo> fullInfo) {
    final Map<String, String> names = {
      for (final info in fullInfo) info.code: info.name,
    };

    return ExchangeRates(
      base: base.copyWith(name: names[base.code] ?? base.name),
      rates: rates.map(
        (currency, rate) => MapEntry(
          currency.copyWith(name: names[currency.code] ?? currency.name),
          rate,
        ),
      ),
    );
  }

  RateExchangedPair convertFrom({
    required CurrencyInfo from,
    required CurrencyInfo to,
    required double amount,
  }) {
    if (from == to) {
      return (rate: 1, exchanged: amount);
    }
    final double rate;
    if(from == base) {
      rate = rates[to]!;
    } else if (to == base) {
      rate = 1 / rates[from]!;
    } else {
      rate = rates[to]! / rates[from]!;
    }

    return (rate: rate, exchanged: amount * rate);
  }

  RateExchangedPair convertTo({
    required CurrencyInfo from,
    required CurrencyInfo to,
    required double amount,
  }) {
    return convertFrom(from: to, to: from, amount: amount);
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

  Future<void> save(ExchangeRates exchangeRates, {bool clearOld = true});
}
