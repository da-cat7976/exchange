import 'package:auto_route/auto_route.dart';
import 'package:exchange/domain/source.dart';
import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/logic/source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SourceSelectorScreen extends ConsumerWidget {
  const SourceSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(sourceControllerProvider);
    final ctr = ref.watch(sourceControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(Icons.chevron_left_rounded),
        ),
        title: Text(t.source.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          final source = RateSource.values[i];
          return ListTile(
            selected: source == current,
            title: Text(t.source.sources(context: source)),
            onTap: () {
              ctr.setSource(source);
              context.pop();
            },
          );
        },
        itemCount: RateSource.values.length,
      ),
    );
  }
}
