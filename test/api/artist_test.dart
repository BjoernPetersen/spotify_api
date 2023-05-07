@Tags(['integration'])
library;

import 'package:spotify_api/spotify_api.dart';
import 'package:test/test.dart';

import '../integration.dart';

class Artist {
  final String id;
  final String name;
  final List<String> popularSongIds;

  const Artist({
    required this.id,
    required this.name,
    this.popularSongIds = const [],
  });
}

const artists = [
  Artist(
      id: '5uFK5OMRw5vqUna1tvbbCG',
      name: 'Kenning West Records',
      popularSongIds: [
        '75n8FqbBeBLW2jUzvjdjXV',
      ]),
  Artist(
      id: '4MEb6a1otZvHceLkDhUgLp',
      name: 'Die Schoppeschlepper',
      popularSongIds: [
        '4y799dt9Y02bvtVHssx9Qo',
        '55bliwQAnhEFiGw1j6bR0F',
      ]),
];

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  tearDownAll(() {
    api.close();
  });

  group('Artists', () {
    group('getArtist', () {
      test('unknown artist', () async {
        expect(
          api.artists.getArtist('5fhEhSIUCUbg0upSko7faC'),
          completion(isNull),
        );
      });

      for (final spec in artists) {
        test(spec.name, () async {
          final artistFuture = api.artists.getArtist(spec.id);
          await expectLater(artistFuture, completion(isNotNull));
          final artist = (await artistFuture)!;
          expect(artist.id, spec.id);
          expect(artist.name, spec.name);
        });
      }
    });
  });
}
