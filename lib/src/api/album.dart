import 'package:meta/meta.dart';
import 'package:spotify_api/spotify_api.dart';
import 'package:spotify_api/src/api/core.dart';

@immutable
class SpotifyAlbumApiImpl implements SpotifyAlbumApi {
  final CoreApi core;

  SpotifyAlbumApiImpl(this.core);

  @override
  Future<Album?> getAlbum(String albumId, {String? market}) async {
    final url = core.resolveUri('/albums/$albumId');

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

    return response.body.decodeJson(Album.fromJson);
  }

  @override
  Future<Page<Track>?> getAlbumTracks(
    String albumId, {
    String? market,
    int? limit,
    int? offset,
  }) async {
    final url = core.resolveUri('/albums/$albumId/tracks');

    final response = await core.client.get(
      url,
      headers: await core.headers,
      params: {
        if (market != null) 'market': market,
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
      },
    );

    if (response.statusCode == 404) {
      return null;
    }

    core.checkErrors(response);

    return response.body.decodeJson(
      (json) => Page.directFromJson(json, Track.fromJson),
    );
  }
}
