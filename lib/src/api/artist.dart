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
}
