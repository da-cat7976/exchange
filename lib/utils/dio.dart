import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

/// Provider for Dio instance, single for all app
///
/// It isn't necessary for now, but is a good starting point for customization
/// such as custom loggers, auth interceptors, etc.
///
/// Note that app ids & api keys is not inserted to dio with interceptor
/// for security reasons: we definitely don't want to provide keys from
/// one rate provider to another. To simplify this task, this keys
/// is inserted into retrofit adapter methods directly.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio();
}
