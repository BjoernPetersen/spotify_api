import 'package:meta/meta.dart';

import 'package:spotify_api/spotify_api.dart';
import 'package:spotify_api/src/api/core.dart';

@immutable
final class SpotifyGenreApiImpl implements SpotifyGenreApi {
  final CoreApi core;

  SpotifyGenreApiImpl(this.core);

  @override
  Future<List<String>> getAvailableGenreSeeds() async {
    final url = core.resolveUri('/recommendations/available-genre-seeds');

    final response = await core.client.get(
      url,
      headers: await core.headers,
    );

    core.checkErrors(response);

    return response.body.decodeJson(AvailableGenreSeeds.fromJson).genres;
  }
}
