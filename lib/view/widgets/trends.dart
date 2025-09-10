import 'dart:math';

import 'package:exchange/domain/trend.dart';
import 'package:exchange/logic/trends.dart';
import 'package:exchange/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:exchange/gen/strings.g.dart';

class TrendView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendState = ref.watch(trendForCurrentProvider);
    final trend = trendState.valueOrNull;
    final Widget child;
    if (trendState.isLoading) {
      child = SizedBox(
        key: ValueKey('loading'),
        width: double.infinity,
        height: 100,
        child: Text(
          t.trends.loading,
          style: context.text.body.copyWith(color: context.color.onSurfaceDimmed),
          textAlign: TextAlign.center,
        ).animate(
          onPlay: (c) => c.repeat(reverse: true)
        ).fade(duration: 1000.ms),
      );
    } else if (trend == null || trend.isEmpty) {
      child = SizedBox();
    } else {
      child = _ActualTrendView(trend: trend);
    }

    return AnimatedSize(
      duration: 300.ms,
      curve: Curves.easeInOut,
      child: child,
    );
  }
}

class _ActualTrendView extends StatelessWidget {
  final Map<DateTime, double> trend;

  const _ActualTrendView({required this.trend});

  @override
  Widget build(BuildContext context) {
    final trendValues = trend.values.toList();
    final spots = [
      for (int i = 0; i < RateTrend.defaultTrendLength; i++)
        FlSpot(i.toDouble(), 1 / trendValues[i]),
    ];

    final minV = spots.reduce((a, b) => a.y < b.y ? a : b).y;
    final maxV = spots.reduce((a, b) => a.y > b.y ? a : b).y;
    final delta = max(maxV - minV, 0.1);

    final screenSize = MediaQuery.of(context).size;

    final color = spots.first.y < spots.last.y
        ? context.color.success
        : context.color.error;

    return Container(
      width: double.infinity,
      height: min(screenSize.width * 2 / 3, screenSize.height / 2),
      margin: EdgeInsets.only(left: 24, right: 40 + 4 * 2),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LineChart(
        LineChartData(
          minY: minV - delta,
          maxY: maxV + delta,
          lineBarsData: [
            LineChartBarData(
              show: true,
              spots: spots,
              isCurved: true,
              dotData: FlDotData(show: false),
              barWidth: 6,
              isStrokeCapRound: true,
              color: color,
            ), // fmt
          ],
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: screenSize.width < (80 * RateTrend.defaultTrendLength)
                    ? 2
                    : 1,
                getTitlesWidget: (value, meta) => Text(
                  _dateFormat.format(
                    DateTime.now().subtract(
                      Duration(
                        days: RateTrend.defaultTrendLength - value.toInt(),
                      ),
                    ),
                  ),
                  style: context.text.label,
                ),
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  static final _dateFormat = DateFormat('dd.MM');
}
