import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension HandleErrorContext on BuildContext {
  void handleErrors(WidgetRef ref, ProviderBase<AsyncValue> provider) {
    ref.listen(provider, (_, state) {
      if (state is! AsyncError) return;

      final error = state.error;
      final msg = switch (error) {
        DriftWrappedException() => t.errors.db(msg: error.message),
        DioException() => t.errors.network(
          msg: error.response?.statusCode ?? t.errors.networkInternal,
        ),
        _ => t.errors.other(msg: error.toString()),
      };

      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: 1.seconds,
          backgroundColor: color.error,
        ),
      );
    });
  }
}
