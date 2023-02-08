@Tags(['integration'])
import 'package:spotify_api/api.dart';
import 'package:test/test.dart';

import '../integration.dart';

const doofTitle = 'Wer das hört ist doof.';
const doofId = '2uORns35GPUssVlNaGs2wS';

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  tearDownAll(() {
    api.close();
  });

  group('Playlists', () {
    group('getCurrentUsersPlaylists', () {
      late final Page<Playlist<PageRef<PlaylistTrack>>> firstPage;
      setUpAll(() async {
        firstPage = await api.playlists.getCurrentUsersPlaylists();
      });

      test('response is not empty', () {
        expect(firstPage.total, isPositive);
      });

      group('full list', () {
        late final List<Playlist<PageRef<PlaylistTrack>>> playlists;

        setUpAll(() async {
          final paginator = await api.paginator(firstPage);
          playlists = await paginator.all(50).toList();
        });

        test('contains doof', () {
          expect(
            playlists
                .map((e) => e.name)
                .where((e) => e == doofTitle)
                .toList(growable: false),
            hasLength(1),
          );
        });

        test('doof has the correct ID', () {
          final doof = playlists.singleWhere((e) => e.name == doofTitle);
          expect(doof.id, doofId);
        });
      });
    });
    group('getPlaylist', () {
      test('unknown playlist', () async {
        final playlist = await api.playlists.getPlaylist(
          '2uERns35GPUssVlNaGs2wS',
        );
        expect(playlist, isNull);
      });

      test('doof', () async {
        final playlist = await api.playlists.getPlaylist(doofId);
        expect(playlist, isNotNull);
        playlist!;
        expect(playlist.id, doofId);
      });
    });
  });
}
