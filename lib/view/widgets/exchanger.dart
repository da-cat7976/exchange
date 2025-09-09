
import 'package:exchange/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Exchanger extends HookConsumerWidget {
  const Exchanger({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        controller: TextEditingController(),
                        label: 'From currency',
                        formatter: _formatter,
                        onTap: () {},
                        currency: 'USD',
                      ),
                    ), // fmt
                    Divider(height: 1),
                    Expanded(
                      child: _CurrencyInput(
                        controller: TextEditingController(),
                        label: 'To currency',
                        formatter: _formatter,
                        onTap: () {},
                        currency: 'RUB',
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

class _CurrencyInput extends StatelessWidget {
  const _CurrencyInput({
    super.key,
    required this.controller,
    required this.label,
    required FilteringTextInputFormatter formatter,
    required this.onTap,
    required this.currency,
  }) : _formatter = formatter;

  final TextEditingController controller;
  final String label;
  final FilteringTextInputFormatter _formatter;
  final Null Function() onTap;
  final String currency;

  @override
  Widget build(BuildContext context) {
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
                hintText: '0.00',
                isDense: true,
              ),
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
