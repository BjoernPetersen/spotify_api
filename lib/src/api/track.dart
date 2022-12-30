import 'package:meta/meta.dart';
import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/api/core.dart';

@immutable
class SpotifyTrackApiImpl implements SpotifyTrackApi {
  final CoreApi core;

  SpotifyTrackApiImpl(this.core);

  @override
  Future<Track?> getTrack(String trackId, {String? market}) async {
    final url = core.resolveUri("/tracks/$trackId");

    final response = await core.client.get(
      url,
      headers: await core.headers,
      params: {
        if (market != null) "market": market,
      },
    );

    if (response.statusCode == 404) {
      return null;
    }

    core.checkErrors(response);

    return response.body.decodeJson(Track.fromJson);
  }
}
