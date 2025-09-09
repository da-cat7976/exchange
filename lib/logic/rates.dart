import 'package:exchange/domain/rate.dart';
import 'package:exchange/logic/source.dart';
import 'package:exchange/service/providers.dart';
import 'package:exchange/storage/providers.dart';
import 'package:exchange/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rates.g.dart';

@riverpod
class RatesController extends _$RatesController {
  @override
  Future<ExchangeRates> build() async {
    final source = ref.watch(sourceControllerProvider);
    final repo = ref.watch(rateRepoProvider);
    final service = ref.watch(exchangeRatesServiceProvider);

    final stored = await repo.get(
      source: source,
      baseCode: source.baseCurrencyCode,
    );
    if (stored != null) state = AsyncData(stored).copyAsLoading();

    final loaded = await service.getRates();
    await repo.save(loaded);

    return loaded;
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
