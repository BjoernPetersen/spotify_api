import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/model.dart';

part 'request.g.dart';

@JsonSerializable()
class Playlist implements RequestModel {
  final String name;
  final bool? public;
  final bool? collaborative;
  final String? description;

  Playlist({
    required this.name,
    this.public,
    this.collaborative,
    this.description,
  });

  @override
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
