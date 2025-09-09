import 'package:exchange/domain/source.dart';
import 'package:exchange/utils/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'source.g.dart';

@riverpod
class SourceController extends _$SourceController {
  @override
  RateSource build() {
    return Env.defaultSource;
  }

  void setSource(RateSource source) {
    state = source;
  }
}
