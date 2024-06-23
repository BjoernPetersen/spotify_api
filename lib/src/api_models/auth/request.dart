import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'request.g.dart';

@immutable
@JsonSerializable(createToJson: false)
final class UserAuthorizationCallbackBody {
  final String state;
  final String? code;
  final String? error;

  UserAuthorizationCallbackBody({
    required this.state,
    required this.code,
    required this.error,
  });

  factory UserAuthorizationCallbackBody.fromJson(Json json) =>
      _$UserAuthorizationCallbackBodyFromJson(json);
}
