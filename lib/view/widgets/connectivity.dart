import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/logic/connection.dart';
import 'package:exchange/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConnectivityBanner extends HookConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectionProvider).valueOrNull ?? true;
    final Widget child;
    if (connectivity) {
      child = SizedBox();
    } else {
      child = Container(
        width: double.infinity,
        color: context.color.error,
        padding: EdgeInsets.all(16),
        child: Text(
          t.errors.noInternet,
          style: context.text.subtitle.copyWith(color: context.color.onSurface),
          textAlign: TextAlign.start,
        ),
      );
    }

    return AnimatedSwitcher(
      duration: 300.ms,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
      child: child,
    );
  }
}
