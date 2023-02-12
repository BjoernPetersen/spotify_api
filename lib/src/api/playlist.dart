import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/requests.dart';

@immutable
class SpotifyPlaylistApiImpl implements SpotifyPlaylistApi {
  final CoreApi core;

  SpotifyPlaylistApiImpl(this.core);

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
}
