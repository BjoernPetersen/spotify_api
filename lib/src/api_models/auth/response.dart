import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class TokenResponse {
  final String accessToken;
  final String? refreshToken;
  final int expiresIn;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}

@immutable
@JsonSerializable()
class AuthorizationCodeResponse {
  final String state;
  final String? code;
  final String? error;

  AuthorizationCodeResponse({
    required this.state,
    required this.code,
    required this.error,
  });

  factory AuthorizationCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationCodeResponseFromJson(json);
}
