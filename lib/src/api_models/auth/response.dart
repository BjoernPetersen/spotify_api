import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'response.g.dart';

@immutable
@JsonSerializable(createToJson: false)
class TokenResponse {
  final String accessToken;
  final String? refreshToken;
  final int expiresIn;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokenResponse.fromJson(Json json) => _$TokenResponseFromJson(json);
}

@immutable
@JsonSerializable(createToJson: false)
class AuthorizationCodeResponse {
  final String state;
  final String? code;
  final String? error;

  AuthorizationCodeResponse({
    required this.state,
    required this.code,
    required this.error,
  });

  factory AuthorizationCodeResponse.fromJson(Json json) =>
      _$AuthorizationCodeResponseFromJson(json);
}
