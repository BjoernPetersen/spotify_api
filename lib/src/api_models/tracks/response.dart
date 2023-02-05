import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/albums/response.dart';
import 'package:spotify_api/src/api_models/artists/response.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class Track {
  /// The album on which the track appears.
  final Album? album;

  /// The artists who performed the track.
  final List<Artist> artists;

  /// A list of the countries in which the track can be played.
  @JsonKey(defaultValue: [])
  final List<String> availableMarkets;

  /// The track length in milliseconds.
  final int durationMs;

  /// The [Spotify ID](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids) for the track.
  final String id;

  /// Whether or not the track has explicit lyrics (false if unknown).
  @JsonKey(name: 'explicit')
  final bool isExplicit;

  /// Whether or not the track is from a local file.
  final bool isLocal;

  /// Part of the response when
  /// [Track Relinking](https://developer.spotify.com/documentation/general/guides/track-relinking-guide/)
  /// is applied. If true, the track is playable in the given market.
  /// Otherwise false.
  final bool? isPlayable;

  /// Part of the response when
  /// [Track Relinking](https://developer.spotify.com/documentation/general/guides/track-relinking-guide/)
  /// is applied, and the requested track has been replaced with different
  /// track. The track in the linked_from object contains information about the
  /// originally requested track.
  final Track? linkedFrom;

  /// The name of the track.
  final String name;

  /// The popularity of the track. The popularity of a track is a value between
  /// 0 and 100, with 100 being the most popular. The popularity is calculated
  /// by algorithm and is based, in the most part, on the total number of plays
  /// the track has had and how recent those plays are.
  ///
  /// Generally speaking, songs that are being played a lot now will have a
  /// higher popularity than songs that were played a lot in the past.
  /// Duplicate tracks (e.g. the same track from a single and an album) are
  /// rated independently. Artist and album popularity is derived mathematically
  /// from track popularity.
  ///
  /// Note: the popularity value may lag behind actual popularity by a few days:
  /// the value is not updated in real time.
  final int? popularity;

  /// A link to a 30 second preview (MP3 format) of the track.
  final String? previewUrl;

  /// The number of the track. If an album has several discs, the track number
  /// is the number on the specified disc.
  final int trackNumber;

  /// The [Spotify URI](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for the track.
  final String uri;

  Track({
    required this.album,
    required this.artists,
    required this.availableMarkets,
    required this.durationMs,
    required this.id,
    required this.isExplicit,
    required this.isLocal,
    required this.isPlayable,
    required this.linkedFrom,
    required this.name,
    required this.popularity,
    required this.previewUrl,
    required this.trackNumber,
    required this.uri,
  });

  factory Track.fromJson(Json json) => _$TrackFromJson(json);
}

@immutable
@JsonSerializable()
class Tracks {
  final List<Track?> tracks;

  Tracks(this.tracks);

  factory Tracks.fromJson(Json json) => _$TracksFromJson(json);
}
