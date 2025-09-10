import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection.g.dart';

@riverpod
Stream<bool> connection(Ref ref) {
  const presentIf = [
    ConnectivityResult.wifi,
    ConnectivityResult.mobile,
    ConnectivityResult.ethernet,
  ];

  return Connectivity().onConnectivityChanged.map(
    (results) => results.any((c) => presentIf.contains(c)),
  );
}
