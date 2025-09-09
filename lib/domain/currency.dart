import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange/domain/source.dart';

part 'currency.g.dart';

/// Info about currency (code, name, e.g).
///
/// Note that name is optional and not used in `==` and `hashcode`
/// for identification purposes.
@CopyWith()
final class CurrencyInfo with EquatableMixin {
  final String code;

  final String name;

  final RateSource source;

  const CurrencyInfo({
    required this.code,
    this.name = '',
    required this.source,
  });

  bool get unnamed => name.isEmpty;

  @override
  List<Object?> get props => [code, source];

  bool isSame(CurrencyInfo other) {
    if (other != this) return false;
    return name == other.name;
  }
}

abstract interface class CurrencyService {
  Future<List<CurrencyInfo>> getAvailableCurrencies();
}

abstract interface class CurrencyRepo {
  Future<List<CurrencyInfo>> listBy(RateSource source);

  Future<void> invalidate({
    required RateSource source,
    Iterable<CurrencyInfo>? except,
  });

  Future<void> saveAll(Iterable<CurrencyInfo> currencies);
}
