import 'package:dio/dio.dart';
import 'package:exchange/utils/env.dart';

class CurrencyApiHistoryInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.baseUrl;
    if (!uri.contains(Env.currencyApiHistoryUrl)) {
      return handler.next(options);
    }

    final date = options.queryParameters['date'];
    if (date is! String) {
      return handler.reject(
        DioException.requestCancelled(
          requestOptions: options,
          reason: 'No date',
        ),
      );
    }

    options.baseUrl = uri.replaceAll('date', date);
    options.queryParameters.remove('date');
    return handler.next(options);
  }
}
