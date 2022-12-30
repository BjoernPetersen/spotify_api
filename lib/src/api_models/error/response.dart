import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class ErrorResponse {
  final ErrorResponseInfo error;

  ErrorResponse(this.error);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

@immutable
@JsonSerializable()
class ErrorResponseInfo {
  final int status;
  final String message;

  ErrorResponseInfo({
    required this.status,
    required this.message,
  });

  factory ErrorResponseInfo.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseInfoFromJson(json);
}
