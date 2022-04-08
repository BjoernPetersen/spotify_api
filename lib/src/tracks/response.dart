import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class Track {
  final String id;

  Track({
    required this.id,
  });

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
