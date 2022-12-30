import 'package:meta/meta.dart';
import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:spotify_api/src/requests.dart';

@immutable
class SpotifyTrackApiImpl implements SpotifyTrackApi {
  final CoreApi core;

  SpotifyTrackApiImpl(this.core);

  @override
  Future<Track?> getTrack(String trackId, {String? market}) async {
    final token = await core.getAccessToken();
    final url = core.resolveUri("/tracks/$trackId");

    final response = await core.client.get(
      url,
      headers: [Header.bearerAuth(token)],
    );

    if (response.statusCode == 404) {
      return null;
    }

    core.checkErrors(response);

    return response.body.decodeJson(Track.fromJson);
  }
}
