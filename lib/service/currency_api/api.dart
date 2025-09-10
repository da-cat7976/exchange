import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract interface class CurrencyApiApi {
  factory CurrencyApiApi(Dio dio, {String? baseUrl}) = _CurrencyApiApi;

  @GET('/currencies.json')
  Future<Map<String, String>> getCurrencies();

  @GET('/currencies/usd.json')
  Future<CurrencyApiRatesRsDto> getRates();
}

@JsonSerializable(createToJson: false)
class CurrencyApiRatesRsDto {
  final DateTime date;

  final Map<String, double> usd;

  const CurrencyApiRatesRsDto({
    required this.date,
    required this.usd,
  });

  factory CurrencyApiRatesRsDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyApiRatesRsDtoFromJson(json);
}