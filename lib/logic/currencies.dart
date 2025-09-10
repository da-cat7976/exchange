import 'package:collection/collection.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/logic/connection.dart';
import 'package:exchange/logic/source.dart';
import 'package:exchange/service/providers.dart';
import 'package:exchange/storage/providers.dart';
import 'package:exchange/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currencies.g.dart';

@riverpod
class CurrenciesController extends _$CurrenciesController {
  @override
  Future<List<CurrencyInfo>> build() async {
    final repo = ref.watch(currencyRepoProvider);
    final service = ref.watch(currencyServiceProvider);

    final source = ref.watch(sourceControllerProvider);
    final stored = await repo.listBy(source);
    if (!await ref.isNetworkAvailable()) {
      return stored;
    }

    state = AsyncData(stored).copyAsLoading();

    final loaded = await service.getAvailableCurrencies();
    await repo.invalidate(source: source, except: loaded);
    await repo.saveAll(loaded);

    return loaded;
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

extension CurrencyGetter on Iterable<CurrencyInfo> {
  CurrencyInfo? getByCode(String? code) {
    if (code == null) return null;
    return firstWhereOrNull((e) => e.code == code);
  }

  CurrencyInfo? presentOrNull(CurrencyInfo? currency) {
    if (currency == null) return null;
    final byCode = getByCode(currency.code);
    if (byCode?.source != currency.source) return null;

    return byCode;
  }
}
