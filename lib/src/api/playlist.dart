import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:meta/meta.dart';

@immutable
class SpotifyPlaylistApiImpl implements SpotifyPlaylistApi {
  final CoreApi core;

  SpotifyPlaylistApiImpl(this.core);

  @override
  Future<Playlist?> getPlaylist(
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
