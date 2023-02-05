import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:spotify_api/src/api_models/model.dart';
part 'response.g.dart';

@immutable
@JsonSerializable()
class ErrorResponse {
  final ErrorResponseInfo error;

  ErrorResponse(this.error);

  factory ErrorResponse.fromJson(Json json) => _$ErrorResponseFromJson(json);
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

  factory ErrorResponseInfo.fromJson(Json json) =>
      _$ErrorResponseInfoFromJson(json);
}
