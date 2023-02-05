import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'request.g.dart';

@JsonSerializable()
class CreatePlaylist implements RequestModel {
  final String? description;
  @JsonKey(name: 'collaborative')
  final bool? isCollaborative;
  @JsonKey(name: 'public')
  final bool? isPublic;
  final String name;

  CreatePlaylist({
    required this.name,
    this.isPublic,
    this.isCollaborative,
    this.description,
  });

  @override
  Map<String, dynamic> toJson() => _$CreatePlaylistToJson(this);
}
