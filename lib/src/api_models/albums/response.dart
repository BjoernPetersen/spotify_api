import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/artists/response.dart';
import 'package:spotify_api/src/api_models/image.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:spotify_api/src/api_models/page.dart';
import 'package:spotify_api/src/api_models/tracks/response.dart';

part 'response.g.dart';

enum AlbumType {
  album,
  single,
  compilation,
  ;

  factory AlbumType.fromJson(String albumType) {
    // In a fascinating twist, Spotify returns enum values in SCREAMING_SNAKE_CASE for the track
    // recommendation endpoint, but in lower case (as documented) otherwise.
    final result = values
        .where((element) => element.name == albumType.toLowerCase())
        .firstOrNull;
    if (result == null) {
      throw ArgumentError.value(albumType, 'albumType');
    }
    return result;
  }
}

enum DatePrecision {
  year,
  month,
  day,
}

@immutable
@JsonSerializable(createToJson: false)
class Album {
  /// The artists of the album.
  final List<Artist> artists;

  /// The markets in which the album is available.
  ///
  /// NOTE: an album is considered available in a market when at least 1
  /// of its tracks is available in that market.
  @JsonKey(defaultValue: [])
  final List<String> availableMarkets;

  final String id;

  /// The cover art for the album in various sizes, widest first.
  final List<Image> images;

  final String name;

  /// The date the album was first released.
  final String releaseDate;

  /// The precision with which [release_date] value is known.
  final DatePrecision releaseDatePrecision;

  @JsonKey(fromJson: parseNumAsInt)
  final int totalTracks;

  /// The tracks of the album. Only present in some responses.
  final Page<Track>? tracks;

  /// The type of the album.
  @JsonKey(name: 'album_type', fromJson: AlbumType.fromJson)
  final AlbumType type;

  /// The [Spotify URI](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for this album.
  final String uri;

  Album({
    required this.artists,
    required this.availableMarkets,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  factory Album.fromJson(Json json) => _$AlbumFromJson(json);
}
