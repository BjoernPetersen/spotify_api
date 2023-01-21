import 'package:meta/meta.dart';
import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/api/core.dart';

@immutable
class SpotifyTrackApiImpl implements SpotifyTrackApi {
  final CoreApi core;

  SpotifyTrackApiImpl(this.core);

  @override
  Future<Track?> getTrack(String trackId, {String? market}) async {
    final url = core.resolveUri('/tracks/$trackId');

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

    return response.body.decodeJson(Track.fromJson);
  }

  @override
  Future<List<Track>> getTracks(
    List<String> trackIds, {
    String? market,
  }) async {
    final url = core.resolveUri('/tracks');

    if (trackIds.length > 50) {
      throw ArgumentError.value(
        trackIds.length,
        'trackIds',
        'trackIds must be 50 at most',
      );
    }

    final response = await core.client.get(
      url,
      headers: await core.headers,
      params: {
        if (market != null) 'market': market,
        'ids': trackIds.join(','),
      },
    );

    core.checkErrors(response);

    return response.body
        .decodeJson(Tracks.fromJson)
        .tracks
        .whereType<Track>()
        .toList(growable: false);
  }
}
