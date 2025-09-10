import 'package:auto_route/auto_route.dart';
import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/logic/currencies.dart';
import 'package:exchange/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CurrencySelectorScreen extends HookConsumerWidget {
  const CurrencySelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencies = ref.watch(currenciesControllerProvider).valueOrNull;
    final filtered = useState(currencies);
    final searchCtr = useTextEditingController();

    Dispose? updateFiltered() {
      filtered.value = currencies
          ?.where(
            (c) =>
                searchCtr.text.isEmpty ||
                c.code.contains(searchCtr.text) ||
                c.name.contains(searchCtr.text),
          )
          .toList();

      return null;
    }

    useEffect(updateFiltered, [currencies]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.color.bg,
        surfaceTintColor: context.color.surface,
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(Icons.chevron_left_rounded),
        ),
        title: Text(t.currencySelector.title),
        bottom: PreferredSize(
          preferredSize: Size(200, 48),
          child: TextField(
            controller: searchCtr,
            onChanged: (v) => updateFiltered(),
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          final currency = filtered.value![i];

          return ListTile(
            subtitle: Text(currency.name),
            title: Text(currency.code),
            onTap: () => context.pop(currency),
          );
        },
        itemCount: filtered.value?.length ?? 0,
      ),
    );
  }
}
