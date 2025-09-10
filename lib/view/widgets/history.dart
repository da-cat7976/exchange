import 'package:exchange/domain/currency.dart';
import 'package:exchange/domain/history.dart';
import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/logic/history.dart';
import 'package:exchange/theme/theme.dart';
import 'package:exchange/view/utils/error.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HistoryHeader extends ConsumerWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyCtr = ref.watch(historyControllerProvider.notifier);
    context.handleErrors(ref, historyProvider);

    return PinnedHeaderSliver(
      child: Container(
        height: 48 + 16 * 2,
        padding: EdgeInsets.fromLTRB(16, 16, 4, 16),
        color: context.color.bg,
        child: Row(
          children: [
            Icon(Icons.history_rounded, color: context.color.onSurfaceDimmed),
            SizedBox(width: 16),
            Text(
              t.history.title,
              style: context.text.subtitle.copyWith(
                color: context.color.onSurfaceDimmed,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: historyCtr.clear,
              icon: Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryView extends HookConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider).valueOrNull;

    return SliverList.builder(
      itemBuilder: (context, i) {
        final entry = history![i];

        final CurrencyInfo from = entry.from;
        final CurrencyInfo to = entry.to;
        final double fromAmount;
        final double toAmount;
        final IconData trailingIcon;

        switch (entry) {
          case FromHistoryEntry():
            fromAmount = entry.fromAmount;
            toAmount = entry.exchanged;
            trailingIcon = Icons.chevron_right_rounded;

          case ToHistoryEntry():
            fromAmount = entry.exchanged;
            toAmount = entry.toAmount;
            trailingIcon = Icons.chevron_left_rounded;
            break;
        }

        return ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(from.code),
              Icon(Icons.chevron_right_rounded, size: 24),
              Text(to.code),
            ],
          ),
          subtitle: Text(
            t.source.sources(context: entry.from.source),
            style: context.text.label,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(fromAmount.toStringAsFixed(2)),
              Icon(trailingIcon, size: 16),
              Text(toAmount.toStringAsFixed(2)),
            ],
          ),
        );
      },
      itemCount: history?.length ?? 0,
    );
  }
}
