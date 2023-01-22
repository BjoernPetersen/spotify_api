@Tags(['integration'])
import 'package:test/test.dart';
import 'package:spotify_api/api.dart';

import '../integration.dart';

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  group('Search', () {
    test('for wodka e', () async {
      final results = await api.search(
        query: 'wodka e',
        types: [SearchType.track],
      );

      final tracks = results.tracks.items;
      expect(tracks, isNotEmpty);
      final firstTrack = tracks[0];
      expect(firstTrack.name, 'Wodka E');
      expect(firstTrack.id, '0wREoBwSaZSHWopt8rNq9S');
      expect(firstTrack.album?.name, 'Wodka E');
      expect(firstTrack.artists, hasLength(1));
      expect(firstTrack.artists[0].name, 'Balek');
    });
  });
}
