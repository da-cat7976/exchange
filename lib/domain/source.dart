enum RateSource {
  /// https://openexchangerates.org/
  openExchangeRates('USD'),
  currencyApi('USD');

  final String baseCurrencyCode;

  const RateSource(this.baseCurrencyCode);
}
