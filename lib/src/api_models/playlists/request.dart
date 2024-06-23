import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:spotify_api/src/api_models/playlists/visibility.dart';

part 'request.g.dart';

@immutable
@JsonSerializable(createFactory: false)
final class CreatePlaylist implements RequestModel {
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
@JsonSerializable(createFactory: false)
final class AddItemsToPlaylist implements RequestModel {
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
@JsonSerializable(createFactory: false)
final class UriObject implements RequestModel {
  final String uri;

  const UriObject(this.uri);

  @override
  Json toJson() => _$UriObjectToJson(this);
}

@immutable
@JsonSerializable(createFactory: false)
final class RemoveItemsFromPlaylist implements RequestModel {
  final List<UriObject> tracks;
  final String snapshotId;

  RemoveItemsFromPlaylist({
    required this.tracks,
    required this.snapshotId,
  });

  RemoveItemsFromPlaylist.fromUris({
    required List<String> uris,
    required this.snapshotId,
  }) : tracks = uris.map((e) => UriObject(e)).toList(growable: false);

  @override
  Json toJson() => _$RemoveItemsFromPlaylistToJson(this);
}

@immutable
@JsonSerializable(createFactory: false)
final class ReplacePlaylistItems implements RequestModel {
  final List<String> uris;

  ReplacePlaylistItems(this.uris);

  @override
  Json toJson() => _$ReplacePlaylistItemsToJson(this);
}

@immutable
@JsonSerializable(createFactory: false)
final class ReorderPlaylistItems implements RequestModel {
  final int insertBefore;
  final int rangeLength;
  final int rangeStart;
  final String snapshotId;

  ReorderPlaylistItems({
    required this.insertBefore,
    required this.rangeLength,
    required this.rangeStart,
    required this.snapshotId,
  });

  @override
  Json toJson() => _$ReorderPlaylistItemsToJson(this);
}
