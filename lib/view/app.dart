import 'package:exchange/navigation/router.dart';
import 'package:exchange/theme/theme.dart';
import 'package:flutter/material.dart';

class ExchangeApp extends StatelessWidget {
  ExchangeApp({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router.config(),
      theme: AppTheme.buildTheme(),
    );
  }
}
