import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/rate.dart';

part 'trend.g.dart';

@CopyWith()
final class RateTrend with EquatableMixin {
  final Map<DateTime, ExchangeRates> rates;

  const RateTrend({required this.rates});

  @override
  List<Object?> get props => [rates];

  static const defaultTrendLength = 7;

  Map<DateTime, double> getForPair({
    required CurrencyInfo from,
    required CurrencyInfo to,
  }) {
    return rates.map(
      (date, rate) =>
          MapEntry(date, rate.convertTo(from: from, to: to, amount: 1).rate),
    );
  }
}

abstract interface class RateTrendService {
  factory RateTrendService() => _StubRateTrendService();

  Future<RateTrend?> getTrend();
}

class _StubRateTrendService implements RateTrendService {
  @override
  Future<RateTrend?> getTrend() async {
    return null;
  }
}
