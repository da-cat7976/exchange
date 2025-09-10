import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:auto_route/auto_route.dart';
import 'package:exchange/domain/currency.dart';
import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/logic/exchange.dart';
import 'package:exchange/logic/history.dart';
import 'package:exchange/navigation/router.gr.dart';
import 'package:exchange/theme/theme.dart';
import 'package:exchange/view/utils/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Exchanger extends HookConsumerWidget {
  const Exchanger({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.handleErrors(ref, exchangeSettingsControllerProvider);
    context.handleErrors(ref, exchangedAmountProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final Widget child;
        if (constraints.maxHeight < 150) {
          child = Center(key: ValueKey('short'), child: _ShortExchanger());
        } else {
          child = Padding(
            key: ValueKey('full'),
            padding: EdgeInsetsGeometry.only(
              left: 24,
              top: 24,
              bottom: 24,
            ),
            child: _FullExchanger(),
          );
        }

        return AnimatedSwitcherPlus.translationRight(
          duration: 300.ms,
          child: child,
        );
      },
    );
  }
}

class _FullExchanger extends HookConsumerWidget {
  const _FullExchanger({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(exchangeSettingsControllerProvider);
    final settingsCtr = ref.watch(exchangeSettingsControllerProvider.notifier);
    final value = settings.valueOrNull;

    final fromCtr = useTextEditingController();
    final toCtr = useTextEditingController();

    final exchanged = ref.watch(exchangedAmountProvider).valueOrNull?.exchanged;
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

    return Row(
      children: [
        Expanded(
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
                        onTapCurrency: () async {
                          final result = await context.pushRoute<CurrencyInfo>(
                            CurrencySelectorRoute(selection: value?.from),
                          );
                          if (result == null) return;

                          settingsCtr.setFrom(result);
                        },
                        onChanged: (value) => settingsCtr.setAmount(
                          amount: double.tryParse(value),
                          direction: ExchangeDirection.fromTo,
                        ),
                        currency: value?.from?.code ?? '',
                      ),
                    ), // fmt
                    Divider(height: 1),
                    Expanded(
                      child: _CurrencyInput(
                        controller: toCtr,
                        label: t.exchanger.to,
                        onTapCurrency: () async {
                          final result = await context.pushRoute<CurrencyInfo>(
                            CurrencySelectorRoute(selection: value?.to),
                          );
                          if (result == null) return;

                          settingsCtr.setTo(result);
                        },
                        onChanged: (value) => settingsCtr.setAmount(
                          amount: double.tryParse(value),
                          direction: ExchangeDirection.toFrom,
                        ),
                        currency: value?.to?.code ?? '',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 56,
          child: IconButton(
            onPressed: () => context.pushRoute(SourceSelectorRoute()),
            icon: Icon(Icons.settings_outlined),
          ),
        ),
      ],
    );
  }
}

class _ShortExchanger extends ConsumerWidget {
  const _ShortExchanger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(exchangeSettingsControllerProvider).valueOrNull;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value?.from?.code ?? '', style: context.text.title),
        Icon(Icons.chevron_right_rounded),
        Text(value?.to?.code ?? '', style: context.text.title),
      ],
    );
  }
}

class _CurrencyInput extends HookConsumerWidget {
  const _CurrencyInput({
    super.key,
    required this.controller,
    required this.label,
    required this.onTapCurrency,
    required this.currency,
    this.onChanged,
  });

  final TextEditingController controller;

  final String label;

  final VoidCallback onTapCurrency;

  final String currency;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyCtr = ref.watch(historyControllerProvider.notifier);
    final node = useFocusNode();

    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: node,
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                hintText: t.exchanger.hint,
                isDense: true,
              ),
              onChanged: onChanged,
              onTapOutside: (_) {
                node.unfocus();
                historyCtr.commitCurrent();
              },
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

  static final _formatter = FilteringTextInputFormatter.allow(
    RegExp(r'^(\d+)?\.?\d{0,2}'),
  );
}
