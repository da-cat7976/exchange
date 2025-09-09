import 'package:exchange/logic/exchange.dart';
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
    final value = settings.valueOrNull;

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
                      child: HookBuilder(
                        builder: (_) => _CurrencyInput(
                          controller: TextEditingController(),
                          label: 'From currency',
                          formatter: _formatter,
                          onTap: () {},
                          onChanged: (value) => ref
                              .read(exchangeSettingsControllerProvider.notifier)
                              .setAmount(
                                amount: double.tryParse(value),
                                direction: ExchangeDirection.fromTo,
                              ),
                          currency: value?.from?.code ?? 'XXX',
                        ),
                      ),
                    ), // fmt
                    Divider(height: 1),
                    Expanded(
                      child: HookConsumer(
                        builder: (_, ref, _) {
                          var ctr = useTextEditingController();

                          final exchanged = ref.watch(exchangedAmountProvider);
                          useEffect(() {
                            ctr.text = exchanged.valueOrNull?.toString() ?? '';
                            return;
                          });

                          return _CurrencyInput(
                            controller: ctr,
                            // label: 'To currency',
                            label: exchanged.valueOrNull.toString(),
                            formatter: _formatter,
                            onTap: () {},
                            currency: value?.to?.code ?? 'XXX',
                          );
                        },
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
    required this.onTap,
    required this.currency,
    this.onChanged,
  }) : _formatter = formatter;

  final TextEditingController controller;

  final String label;

  final FilteringTextInputFormatter _formatter;

  final VoidCallback onTap;

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
              // controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                hintText: '0.00',
                isDense: true,
              ),
              onChanged: onChanged,
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [_formatter],
            ),
          ),
          InkWell(
            onTap: onTap,
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
