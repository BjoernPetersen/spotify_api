import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/image.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'response.g.dart';

@immutable
@JsonSerializable(createToJson: false)
class User {
  /// The country of the user, as set in the user's account profile.
  /// An [ISO 3166-1 alpha-2](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
  /// country code.
  ///
  /// This field is only available when the current user has granted access to
  /// the `user-read-private` scope.
  final String? country;

  /// The name displayed on the user's profile.
  final String? displayName;

  /// The user's email address, as entered by the user when creating their
  /// account.
  ///
  /// **Important!** This email address is unverified; there is no proof that it
  /// actually belongs to the user.
  ///
  /// This field is only available when the current user has granted access to
  /// the `user-read-email` scope.
  final String? email;

  /// The user's explicit content settings.
  ///
  /// This field is only available when the current user has granted access to
  /// the `user-read-private` scope.
  final ExplicitContentSettings? explicitContent;

  /// A link to the Web API endpoint for this user.
  final String href;

  /// The
  /// [Spotify user ID](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for the user.
  final String id;

  /// The user's profile image.
  @JsonKey(defaultValue: [])
  final List<Image> images;

  /// The user's Spotify subscription level: "premium", "free", etc.
  ///
  /// (The subscription level "open" can be considered the same as "free".)
  ///
  /// This field is only available when the current user has granted access to
  /// the `user-read-private` scope.
  final String? product;

  /// The [Spotify URI](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for the user.
  final String uri;

  User({
    required this.country,
    required this.displayName,
    required this.email,
    required this.explicitContent,
    required this.href,
    required this.id,
    required this.images,
    required this.product,
    required this.uri,
  });

  factory User.fromJson(Json json) => _$UserFromJson(json);
}

@immutable
@JsonSerializable(createToJson: false)
class ExplicitContentSettings {
  /// When true, indicates that explicit content should not be played.
  final bool filterEnabled;

  /// When true, indicates that the explicit content setting is locked and can't
  /// be changed by the user.
  final bool filterLocked;

  ExplicitContentSettings({
    required this.filterEnabled,
    required this.filterLocked,
  });

  factory ExplicitContentSettings.fromJson(Json json) =>
      _$ExplicitContentSettingsFromJson(json);
}
