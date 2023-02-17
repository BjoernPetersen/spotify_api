import 'package:spotify_api/spotify_api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/requests.dart';

@immutable
class SpotifyPlaylistApiImpl implements SpotifyPlaylistApi {
  final CoreApi core;

  SpotifyPlaylistApiImpl(this.core);

  @override
  Future<String> addItemsToPlaylist({
    required String playlistId,
    required List<String> uris,
    int? position,
  }) async {
    final url = core.resolveUri('/playlists/$playlistId/tracks');

    final response = await core.client.post(
      url,
      headers: await core.headers,
      body: RequestBody.json(AddItemsToPlaylist(
        uris: uris,
        position: position,
      )),
    );

    core.checkErrors(response);

    return response.body.decodeJson(PlaylistSnapshot.fromJson).snapshotId;
  }

  @override
  Future<Playlist<Page<PlaylistTrack>>> createPlaylist({
    required String userId,
    required String name,
    PlaylistVisibility? visibility,
    String? description,
  }) async {
    final url = core.resolveUri('/users/$userId/playlists');

    final response = await core.client.post(
      url,
      headers: await core.headers,
      body: RequestBody.json(CreatePlaylist.withVisibility(
        name: name,
        visibility: visibility,
        description: description,
      )),
    );

    core.checkErrors(response);

    return response.body.decodeJson(Playlist.fromJson);
  }

  @override
  Future<Page<Playlist<PageRef<PlaylistTrack>>>>
      getCurrentUsersPlaylists() async {
    final url = core.resolveUri('/me/playlists');

    final response = await core.client.get(
      url,
      headers: await core.headers,
    );

    core.checkErrors(response);

    return response.body.decodeJson(
      (json) => Page.directFromJson(json, Playlist.fromJson),
    );
  }

  @override
  Future<Playlist<Page<PlaylistTrack>>?> getPlaylist(
    String id, {
    String? market,
  }) async {
    final url = core.resolveUri('/playlists/$id');

    final response = await core.client.get(
      url,
      headers: await core.headers,
      params: {
        if (market != null) 'market': market,
      },
    );

    if (response.statusCode == 404) {
      return null;
    }

    core.checkErrors(response);

    return response.body.decodeJson(Playlist.fromJson);
  }

  @override
  Future<List<Image>> getPlaylistCoverImage(String playlistId) async {
    final url = core.resolveUri('/playlists/$playlistId/images');

    final response = await core.client.get(
      url,
      headers: await core.headers,
    );

    core.checkErrors(response);

    return response.body.decodeJsonList(Image.fromJson);
  }

  @override
  Future<Page<PlaylistTrack>> getPlaylistItems(
    String playlistId, {
    String? market,
    int? limit,
    int? offset,
  }) async {
    final url = core.resolveUri('/playlists/$playlistId/tracks');

    final response = await core.client.get(
      url,
      headers: await core.headers,
    );

    core.checkErrors(response);

    return response.body.decodeJson(
      (json) => Page.directFromJson(json, PlaylistTrack.fromJson),
    );
  }

  @override
  Future<String> removePlaylistItems({
    required String playlistId,
    required List<String> uris,
    required String snapshotId,
  }) async {
    final url = core.resolveUri('/playlists/$playlistId/tracks');

    final response = await core.client.delete(
      url,
      headers: await core.headers,
      body: RequestBody.json(RemoveItemsFromPlaylist(
        uris: uris,
        snapshotId: snapshotId,
      )),
    );

    core.checkErrors(response);

    return response.body.decodeJson(PlaylistSnapshot.fromJson).snapshotId;
  }

  @override
  Future<String> reorderPlaylistItems({
    required String playlistId,
    required String snapshotId,
    required int rangeStart,
    required int insertBefore,
    int rangeLength = 1,
  }) async {
    final url = core.resolveUri('/playlists/$playlistId/tracks');

    final response = await core.client.put(
      url,
      headers: await core.headers,
      body: RequestBody.json(ReorderPlaylistItems(
        insertBefore: insertBefore,
        rangeLength: rangeLength,
        rangeStart: rangeStart,
        snapshotId: snapshotId,
      )),
    );

    core.checkErrors(response);

    return response.body.decodeJson(PlaylistSnapshot.fromJson).snapshotId;
  }

  @override
  Future<String> replacePlaylistItems({
    required String playlistId,
    required List<String> uris,
  }) async {
    final url = core.resolveUri('/playlists/$playlistId/tracks');

    final response = await core.client.put(
      url,
      headers: await core.headers,
      body: RequestBody.json(ReplacePlaylistItems(uris)),
    );

    core.checkErrors(response);

    return response.body.decodeJson(PlaylistSnapshot.fromJson).snapshotId;
  }
}
