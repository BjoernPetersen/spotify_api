import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/image.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:spotify_api/src/api_models/page.dart';
import 'package:spotify_api/src/api_models/playlists/visibility.dart';
import 'package:spotify_api/src/api_models/tracks/response.dart';
import 'package:spotify_api/src/api_models/users/response.dart';

part 'response.g.dart';

@immutable
@JsonSerializable(createToJson: false)
final class PlaylistTrack {
  final bool isLocal;
  final DateTime? addedAt;
  final User? addedBy;
  final Track track;

  PlaylistTrack({
    required this.addedAt,
    required this.addedBy,
    required this.isLocal,
    required this.track,
  });

  factory PlaylistTrack.fromJson(Json json) => _$PlaylistTrackFromJson(json);
}

@immutable
@JsonSerializable(createToJson: false)
final class Playlist<TrackPage extends PageRef<PlaylistTrack>> {
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
  @JsonKey(defaultValue: [])
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
  ///
  /// **Warning:** the API returns inconsistent values for the public status.
  /// It seems that using the getPlaylist(id) endpoint gives the best results.
  @JsonKey(name: 'public')
  final bool? isPublic;

  /// The name of the playlist.
  final String name;

  /// The user who owns the playlist.
  final User owner;

  /// The version identifier for the current playlist.
  /// Can be supplied in other requests to target a specific playlist version.
  final String snapshotId;

  /// THe tracks of the playlist.
  final TrackPage tracks;

  /// The
  /// [Spotify URI](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for the playlist.
  final String uri;

  PlaylistVisibility? get visibility {
    if (isCollaborative) {
      return PlaylistVisibility.collaborative;
    }
    switch (isPublic) {
      case true:
        return PlaylistVisibility.public;
      case false:
        return PlaylistVisibility.private;
      case null:
      default:
        return null;
    }
  }

  Playlist({
    required this.description,
    required this.id,
    required this.images,
    required this.isCollaborative,
    required this.isPublic,
    required this.name,
    required this.owner,
    required this.snapshotId,
    required this.tracks,
    required this.uri,
  });

  factory Playlist.fromJson(Json json) => _$PlaylistFromJson(
        json,
        (json) => PageRef.fromJson(
          json as Json,
          PlaylistTrack.fromJson,
        ) as TrackPage,
      );
}

@immutable
@JsonSerializable(createToJson: false)
final class PlaylistSnapshot {
  final String snapshotId;

  PlaylistSnapshot(this.snapshotId);

  factory PlaylistSnapshot.fromJson(Json json) =>
      _$PlaylistSnapshotFromJson(json);
}
