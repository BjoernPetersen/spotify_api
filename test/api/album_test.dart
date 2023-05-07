@Tags(['integration'])
library;
import 'package:spotify_api/spotify_api.dart';
import 'package:test/test.dart';

import '../integration.dart';

class Album {
  final String id;
  final AlbumType type;
  final String name;
  final String artistName;
  final int trackCount;

  const Album({
    required this.id,
    required this.type,
    required this.name,
    required this.artistName,
    required this.trackCount,
  });
}

const albums = [
  Album(
    id: '6QfaZ05cdm3h2mOp8D7GD4',
    type: AlbumType.album,
    name: 'I fucking love my life',
    artistName: 'Faber',
    trackCount: 16,
  ),
  Album(
    id: '4fhEhSIUCUbg0upSko7faC',
    type: AlbumType.single,
    name: 'Kenning West, Alder',
    artistName: 'Kenning West Records',
    trackCount: 1,
  ),
];

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  tearDownAll(() {
    api.close();
  });

  group('Albums', () {
    group('getAlbum', () {
      test('unknown album', () async {
        final album = await api.albums.getAlbum('5fhEhSIUCUbg0upSko7faC');
        expect(album, isNull);
      });

      for (final album in albums) {
        test(album.name, () async {
          final result = await api.albums.getAlbum(album.id);
          expect(result, isNotNull);
          result!;
          expect(result.id, album.id);
          expect(result.name, album.name);
          expect(result.artists, hasLength(1));
          expect(result.artists[0].name, album.artistName);
          expect(result.totalTracks, album.trackCount);
          expect(result.type, album.type);
        });
      }
    });

    group('getAlbumTracks', () {
      for (final album in albums) {
        test('for ${album.name}', () async {
          final trackPage = await api.albums.getAlbumTracks(
            album.id,
            limit: 40,
          );
          expect(trackPage, isNotNull);
          trackPage!;
          final paginator = await api.paginator(trackPage);
          final tracks = await paginator.all().toList();
          expect(tracks, hasLength(album.trackCount));
        });
      }
    });
  });
}
