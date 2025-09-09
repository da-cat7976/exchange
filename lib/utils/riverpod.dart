import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueLoading<T> on AsyncData<T> {
  AsyncValue<T> copyAsLoading() => AsyncLoading<T>().copyWithPrevious(this);
}
