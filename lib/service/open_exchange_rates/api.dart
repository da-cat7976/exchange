import 'package:dio/dio.dart';
import 'package:exchange/utils/env.dart';
import 'package:exchange/utils/json.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: Env.openExchangeRatesApi)
abstract interface class OpenExchangeRatesApi {
  factory OpenExchangeRatesApi(Dio dio, {String? baseUrl}) =
      _OpenExchangeRatesApi;

  @GET('/currencies.json')
  Future<Map<String, String>> getCurrencies({
    @Query('app_id') String appId = Env.openExchangeRatesAppId,
  });

  @GET('/latest.json')
  Future<OerRatesRsDto> getRates({
    @Query('app_id') String appId = Env.openExchangeRatesAppId,
  });
}

@JsonSerializable(createToJson: false)
final class OerRatesRsDto {
  @unixDateTime
  final DateTime timestamp;

  final String base;

  final Map<String, double> rates;

  const OerRatesRsDto({
    required this.timestamp,
    required this.base,
    required this.rates,
  });

  factory OerRatesRsDto.fromJson(Map<String, dynamic> json) =>
      _$OerRatesRsDtoFromJson(json);
}
