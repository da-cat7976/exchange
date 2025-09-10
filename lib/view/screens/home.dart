import 'package:auto_route/auto_route.dart';
import 'package:exchange/theme/theme.dart';
import 'package:exchange/view/widgets/connectivity.dart';
import 'package:exchange/view/widgets/exchanger.dart';
import 'package:exchange/view/widgets/history.dart';
import 'package:exchange/view/widgets/trends.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: context.color.bg,
                  surfaceTintColor: context.color.bg,
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () => showLicensePage(context: context),
                        icon: Icon(Icons.info_outline_rounded),
                      ),
                    ),
                  ],
                  flexibleSpace: Exchanger(),
                  expandedHeight: 200,
                ),
                SliverToBoxAdapter(child: TrendView()),
                HistoryHeader(),
                HistoryView(),
              ],
            ),
          ),
          ConnectivityBanner(),
        ],
      ),
    );
  }
}
