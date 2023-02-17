import 'package:meta/meta.dart';
import 'package:spotify_api/src/api/api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:spotify_api/src/api_models/page.dart';
import 'package:spotify_api/src/api_models/tracks/response.dart';

@immutable
class SpotifyTrackApiImpl implements SpotifyTrackApi {
  final CoreApi core;

  SpotifyTrackApiImpl(this.core);

  @override
  Future<List<bool>> checkUsersSavedTracks(List<String> ids) async {
    if (ids.isEmpty) {
      throw ArgumentError.value(ids, 'ids', 'ids may not be empty');
    }

    final url = core.resolveUri('/me/tracks/contains');

    final response = await core.client.get(
      url,
      headers: await core.headers,
      params: {
        'ids': ids.join(','),
      },
    );

    core.checkErrors(response);

    return response.body.decodeJsonPrimitiveList();
  }

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

  @override
  Future<Page<SavedTrack>> getSavedTracks({
    int? limit,
    String? market,
  }) async {
    final url = core.resolveUri('/me/tracks');

    final response = await core.client.get(
      url,
      headers: await core.headers,
      params: {
        if (limit != null) 'limit': limit.toString(),
        if (market != null) 'market': market,
      },
    );

    core.checkErrors(response);

    return response.body.decodeJson(
      (json) => Page.directFromJson(
        json,
        SavedTrack.fromJson,
      ),
    );
  }

  @override
  Future<void> removeUsersSavedTracks(List<String> ids) async {
    if (ids.isEmpty) {
      throw ArgumentError.value(ids, 'ids', 'ids may not be empty');
    }

    final url = core.resolveUri('/me/tracks');

    final response = await core.client.delete(
      url,
      body: null,
      headers: await core.headers,
      params: {
        'ids': ids.join(','),
      },
    );

    core.checkErrors(response);
  }

  @override
  Future<void> saveTracksForCurrentUser(List<String> ids) async {
    if (ids.isEmpty) {
      throw ArgumentError.value(ids, 'ids', 'ids may not be empty');
    }

    final url = core.resolveUri('/me/tracks');

    final response = await core.client.put(
      url,
      body: null,
      headers: await core.headers,
      params: {
        'ids': ids.join(','),
      },
    );

    core.checkErrors(response);
  }
}
