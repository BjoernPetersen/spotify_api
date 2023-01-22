import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/pagination.dart';
import 'package:spotify_api/src/api_models/albums/response.dart';
import 'package:spotify_api/src/api_models/tracks/response.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class SearchResponse {
  final Page<Album>? albums;
  final Page<Track>? tracks;

  SearchResponse({
    required this.albums,
    required this.tracks,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}
