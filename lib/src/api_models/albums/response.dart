import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/api.dart';

part 'response.g.dart';

enum AlbumType {
  album,
  single,
  compilation,
}

enum DatePrecision {
  year,
  month,
  day,
}

@immutable
@JsonSerializable()
class Album {
  /// The markets in which the album is available.
  ///
  /// NOTE: an album is considered available in a market when at least 1
  /// of its tracks is available in that market.
  final List<String> availableMarkets;

  final String id;

  /// The cover art for the album in various sizes, widest first.
  final List<Image> images;

  final String name;

  /// The date the album was first released.
  final String releaseDate;

  /// The precision with which [release_date] value is known.
  final DatePrecision releaseDatePrecision;

  final int totalTracks;

  /// The tracks of the album. Only present in some responses.
  final Page<Track>? tracks;

  /// The type of the album.
  @JsonKey(name: 'album_type')
  final AlbumType type;

  /// The [Spotify URI](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids)
  /// for this album.
  final String uri;

  Album({
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

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
