import 'package:exchange/domain/source.dart';

abstract class Env {
  const Env._();

  static const String openExchangeRatesApi = String.fromEnvironment('oerApi');

  static const String openExchangeRatesAppId = String.fromEnvironment(
    'oerAppId',
  );

  static const String currencyApiUrl = String.fromEnvironment('currencyApiUrl');

  static const String currencyApiHistoryUrl = String.fromEnvironment('currencyApiHistory');

  static const String _defaultSource = String.fromEnvironment('defaultSource');

  static const String defaultFrom = String.fromEnvironment('defaultFrom');

  static const String defaultTo = String.fromEnvironment('defaultTo');

  static const int defaultAmount = int.fromEnvironment('defaultAmount');

  static RateSource get defaultSource {
    return RateSource.values.firstWhere(
      (source) => source.name.toLowerCase() == _defaultSource.toLowerCase(),
    );
  }
}
