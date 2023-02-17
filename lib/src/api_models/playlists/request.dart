import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:spotify_api/src/api_models/playlists/visibility.dart';

part 'request.g.dart';

@immutable
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

  CreatePlaylist.withVisibility({
    required this.name,
    required PlaylistVisibility? visibility,
    required this.description,
  })  : isCollaborative = visibility == null
            ? null
            : visibility == PlaylistVisibility.collaborative,
        isPublic =
            visibility == null ? null : visibility == PlaylistVisibility.public;

  @override
  Json toJson() => _$CreatePlaylistToJson(this);
}

@immutable
@JsonSerializable()
class AddItemsToPlaylist implements RequestModel {
  final List<String> uris;
  final int? position;

  AddItemsToPlaylist({
    required this.uris,
    required this.position,
  });

  @override
  Json toJson() => _$AddItemsToPlaylistToJson(this);
}

@immutable
@JsonSerializable()
class RemoveItemsFromPlaylist implements RequestModel {
  final List<String> uris;
  final String snapshotId;

  RemoveItemsFromPlaylist({
    required this.uris,
    required this.snapshotId,
  });

  @override
  Json toJson() => _$RemoveItemsFromPlaylistToJson(this);
}
