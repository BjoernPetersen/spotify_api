import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/artists/response.dart';
import 'package:spotify_api/src/api_models/page.dart';
import 'package:spotify_api/src/api_models/albums/response.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:spotify_api/src/api_models/playlists/response.dart';
import 'package:spotify_api/src/api_models/tracks/response.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class SearchResponse {
  final Page<Album>? albums;
  final Page<Artist>? artists;
  final Page<Playlist<PageRef<PlaylistTrack>>>? playlists;
  final Page<Track>? tracks;

  SearchResponse({
    required this.albums,
    required this.artists,
    required this.playlists,
    required this.tracks,
  });

  factory SearchResponse.fromJson(Json json) => _$SearchResponseFromJson(json);
}
