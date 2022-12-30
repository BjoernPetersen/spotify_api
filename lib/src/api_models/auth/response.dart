import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class AccessToken {
  final String accessToken;
  final int expiresIn;

  AccessToken({
    required this.accessToken,
    required this.expiresIn,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);
}
