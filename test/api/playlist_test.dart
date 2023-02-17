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
                .map((e) => e.id)
                .where((e) => e == doofId)
                .toList(growable: false),
            hasLength(1),
          );
        });

        group('doof', () {
          late final Playlist<PageRef<PlaylistTrack>> doof;

          setUpAll(() {
            doof = playlists.singleWhere((e) => e.id == doofId);
          });

          test('has the correct metadata', () {
            expect(doof.id, doofId);
            expect(doof.name, doofTitle);
            // This is inconsistent for this endpoint
            // expect(doof.isPublic, true);
            expect(doof.isCollaborative, false);
            expect(doof.description, 'Wie bin ich hierhergekommen?');
            expect(doof.owner, isNotNull);
          });

          test('has at least 300 tracks', () async {
            final tracks = doof.tracks;
            final paginator = await api.paginator(tracks);
            expect(
              paginator.all(50).take(300).toList(),
              completion(hasLength(300)),
            );
          });
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
        expect(playlist.name, doofTitle);
        expect(playlist.isPublic, true);
        expect(playlist.isCollaborative, false);
        expect(playlist.description, 'Wie bin ich hierhergekommen?');
        expect(playlist.owner, isNotNull);
      });
    });
    group('getPlaylistCoverImage', () {
      test('for doof', () async {
        final result = api.playlists.getPlaylistCoverImage(doofId);
        await expectLater(result, completes);
        final images = await result;
        expect(images, isNotEmpty);
        for (final image in images) {
          expect(image.url, allOf(isNotNull, isNotEmpty));
        }
      });
    });
  });
}
