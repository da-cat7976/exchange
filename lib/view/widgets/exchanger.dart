import 'package:auto_route/auto_route.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/logic/exchange.dart';
import 'package:exchange/navigation/router.gr.dart';
import 'package:exchange/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Exchanger extends HookConsumerWidget {
  const Exchanger({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(exchangeSettingsControllerProvider);
    final settingsCtr = ref.watch(exchangeSettingsControllerProvider.notifier);
    final value = settings.valueOrNull;

    final fromCtr = useTextEditingController();
    final toCtr = useTextEditingController();

    final exchanged = ref.watch(exchangedAmountProvider).valueOrNull;
    final exchangedStr = exchanged != null ? exchanged.toStringAsFixed(2) : '';

    useEffect(() {
      switch (value?.direction) {
        case ExchangeDirection.fromTo:
          toCtr.text = exchangedStr;

        case ExchangeDirection.toFrom:
          fromCtr.text = exchangedStr;

        default:
          break;
      }

      return;
    }, [exchangedStr]);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < 150) return SizedBox();
        final horizontalPadding = constraints.maxWidth / 9;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(color: context.color.surface),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: _CurrencyInput(
                        controller: fromCtr,
                        label: t.exchanger.from,
                        formatter: _formatter,
                        onTapCurrency: () async {
                          final result = await context.pushRoute<CurrencyInfo>(
                            CurrencySelectorRoute(),
                          );
                          if (result == null) return;

                          settingsCtr.setFrom(result);
                        },
                        onChanged: (value) => settingsCtr.setAmount(
                          amount: double.tryParse(value),
                          direction: ExchangeDirection.fromTo,
                        ),
                        currency: value?.from?.code ?? 'XXX',
                      ),
                    ), // fmt
                    Divider(height: 1),
                    Expanded(
                      child: _CurrencyInput(
                        controller: toCtr,
                        label: t.exchanger.to,
                        formatter: _formatter,
                        onTapCurrency: () async {
                          final result = await context.pushRoute<CurrencyInfo>(
                            CurrencySelectorRoute(),
                          );
                          if (result == null) return;

                          settingsCtr.setTo(result);
                        },
                        onChanged: (value) => settingsCtr.setAmount(
                          amount: double.tryParse(value),
                          direction: ExchangeDirection.toFrom,
                        ),
                        currency: value?.to?.code ?? 'XXX',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static final _formatter = FilteringTextInputFormatter.allow(
    RegExp(r'^(\d+)?\.?\d{0,2}'),
  );
}

class _CurrencyInput extends HookConsumerWidget {
  const _CurrencyInput({
    super.key,
    required this.controller,
    required this.label,
    required FilteringTextInputFormatter formatter,
    required this.onTapCurrency,
    required this.currency,
    this.onChanged,
  }) : _formatter = formatter;

  final TextEditingController controller;

  final String label;

  final FilteringTextInputFormatter _formatter;

  final VoidCallback onTapCurrency;

  final String currency;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                hintText: t.exchanger.hint,
                isDense: true,
              ),
              onChanged: onChanged,
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [_formatter],
            ),
          ),
          InkWell(
            onTap: onTapCurrency,
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text(currency)),
            ),
          ),
        ],
      ),
    );
  }
}
