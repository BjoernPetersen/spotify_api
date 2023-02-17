@Tags(['integration'])
import 'package:test/test.dart';
import 'package:spotify_api/api.dart';

import '../integration.dart';

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  tearDownAll(() {
    api.close();
  });

  test('closing works', () async {
    final api = await loadApi();
    expect(api.close, returnsNormally);
    expect(
      api.search(query: 'test', types: [SearchType.track]),
      throwsException,
    );
  });

  group('Search', () {
    group('songs:', () {
      test('wodka e', () async {
        final results = await api.search(
          query: 'wodka e',
          types: [SearchType.track],
        );

        final tracks = results.tracks?.items;
        expect(tracks, allOf(isNotNull, isNotEmpty));
        final firstTrack = tracks![0];
        expect(firstTrack.name, 'Wodka E');
        expect(firstTrack.id, '0wREoBwSaZSHWopt8rNq9S');
        expect(firstTrack.album?.name, 'Wodka E');
        expect(firstTrack.artists, hasLength(1));
        expect(firstTrack.artists[0].name, 'Balek');
      });
    });

    group('albums:', () {
      test('gebrüder lalaberg', () async {
        final results = await api.search(
          query: 'gebrüder lalaberg',
          types: [SearchType.album],
        );
        final albums = results.albums?.items;
        expect(albums, allOf(isNotNull, isNotEmpty));
        final first = albums![0];
        expect(first.name, 'Lalaberg');
        expect(first.releaseDate, '2017-10-06');
        expect(first.artists, hasLength(1));
        expect(first.artists[0].name, 'Gebrüder');
      });
    });

    group('playlists:', () {
      test('die dusch playlist', () async {
        final results = await api.search(
          query: 'die dusch playlist',
          types: [SearchType.playlist],
        );
        final playlists = results.playlists?.items;
        expect(playlists, isNotEmpty);
        playlists!;
        final playlist = playlists[0];
        expect(playlist.id, '4YArDKpHGrn7xNLQQsWUnh');
      });
    });
  });
}
