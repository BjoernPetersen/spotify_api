import 'package:spotify_api/spotify_api.dart';
import 'package:spotify_api/src/api/core.dart';

class SpotifyArtistApiImpl implements SpotifyArtistApi {
  final CoreApi core;

  SpotifyArtistApiImpl(this.core);

  @override
  Future<Artist?> getArtist(String artistId) async {
    final url = core.resolveUri('/artists/$artistId');

    final response = await core.client.get(
      url,
      headers: await core.headers,
    );

    if (response.statusCode == 404) {
      return null;
    }

    core.checkErrors(response);

    return response.body.decodeJson(Artist.fromJson);
  }

  @override
  Future<List<Track>> getTopTracks({
    required String artistId,
    required String market,
  }) async {
    final url = core.resolveUri('/artists/$artistId/top-tracks');

    final response = await core.client.get(
      url,
      headers: await core.headers,
      params: {
        'market': market,
      },
    );

    if (response.statusCode == 400) {
      final body = response.body.decodeJson(ErrorResponse.fromJson);
      final message = body.error.message.toLowerCase();
      if (message == 'invalid id') {
        throw NotFoundException(
          type: ResourceType.artist,
          id: artistId,
        );
      } else if (message == 'invalid market code') {
        throw NotFoundException(
          type: ResourceType.market,
          id: market,
        );
      }
    }

    if (response.statusCode == 404) {
      throw NotFoundException(type: ResourceType.artist, id: artistId);
    }

    core.checkErrors(response);

    return response.body
        .decodeJson(Tracks.fromJson)
        .tracks
        .whereType<Track>()
        .toList(growable: false);
  }
}
