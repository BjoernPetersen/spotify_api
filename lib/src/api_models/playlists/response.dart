import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/api_models/image.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:spotify_api/src/api_models/pagination.dart';
import 'package:spotify_api/src/api_models/tracks/response.dart';

part 'response.g.dart';

@JsonSerializable()
class Playlist {
  /// The playlist description.
  ///
  /// Only returned for modified, verified playlists, otherwise null.
  final String? description;

  /// The
  /// [Spotify ID](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for the playlist.
  final String id;

  /// Images for the playlist.
  ///
  /// The array may be empty or contain up to three images.
  /// The images are returned by size in descending order.
  ///
  /// **Note:** if returned, the source URL for the image is temporary and
  /// will expire in less than a day.
  final List<Image> images;

  /// Whether the owner allows other users to modify the playlist.
  @JsonKey(name: 'collaborative')
  final bool isCollaborative;

  /// The playlist's public/private status:
  /// - `true`: the playlist is public,
  /// - `false`: the playlist is private
  /// - `null`: the playlist status is not relevant
  ///
  /// For more about public/private status, see
  /// [Working with Playlists](https://developer.spotify.com/documentation/general/guides/working-with-playlists/).
  @JsonKey(name: 'public')
  final bool? isPublic;

  /// The name of the playlist.
  final String name;

  // TODO: owner information

  /// The version identifier for the current playlist.
  /// Can be supplied in other requests to target a specific playlist version.
  final String snapshotId;

  /// THe tracks of the playlist.
  final Page<Track> tracks;

  /// The
  /// [Spotify URI](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for the playlist.
  final String uri;

  Playlist({
    required this.description,
    required this.id,
    required this.images,
    required this.isCollaborative,
    required this.isPublic,
    required this.name,
    required this.snapshotId,
    required this.tracks,
    required this.uri,
  });

  factory Playlist.fromJson(Json json) => _$PlaylistFromJson(json);
}
