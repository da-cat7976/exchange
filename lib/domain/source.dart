enum RateSource {
  /// https://openexchangerates.org/
  openExchangeRates('USD');

  final String baseCurrencyCode;

  const RateSource(this.baseCurrencyCode);
}
