@Tags(['integration'])
library;

import 'package:spotify_api/spotify_api.dart';
import 'package:test/test.dart';

import '../integration.dart';

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  tearDownAll(() {
    api.close();
  });

  group('Genres', () {
    test('getAvailableGenreSeeds', () async {
      expect(
        api.genres.getAvailableGenreSeeds(),
        completion(isNotEmpty),
      );
    });
  });
}
