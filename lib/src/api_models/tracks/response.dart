import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/artists/response.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
class Track {
  final String id;
  final String name;
  final List<Artist> artists;

  Track({
    required this.id,
    required this.name,
    required this.artists,
  });

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
