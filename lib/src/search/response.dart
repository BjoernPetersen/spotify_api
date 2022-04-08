import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/paging.dart';
import 'package:spotify_api/src/tracks/response.dart';

part 'response.g.dart';

@JsonSerializable()
class SearchResponse {
  final Page<Track> tracks;

  SearchResponse({
    required this.tracks,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => _$SearchResponseFromJson(json);
}
