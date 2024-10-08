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
      test('unknown artist', () {
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

    group('getArtists', () {
      test('empty list', () {
        expect(
          api.artists.getArtists([]),
          throwsArgumentError,
        );
      });

      test('too many IDs', () {
        final ids = List.generate(51, (_) => 'invalid-id');
        expect(
          api.artists.getArtists(ids),
          throwsArgumentError,
        );
      });

      test('invalid ID', () {
        expect(
          api.artists.getArtists(['6K5OMRw5vqUna1tvbbCG']),
          throwsA(
            isA<SpotifyApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.message, 'message', contains('Invalid')),
          ),
        );
      });

      test('unknown ID', () {
        expect(
          api.artists.getArtists(['6uFK5OMRw5vqUna1tvbbCG']),
          completion(isEmpty),
        );
      });

      test('example artists', () async {
        await expectLater(
            api.artists.getArtists(artists.map((it) => it.id).toList()),
            completion(hasLength(2)));
      });
    });

    group('getTopTracks', () {
      test('unknown artist', () {
        final id = '6uFK5OMRw5vqUna1tvbbCG';
        expect(
          api.artists.getTopTracks(artistId: id, market: 'de'),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('invalid artist ID', () {
        final id = '6K5OMRw5vqUna1tvbbCG';
        expect(
          api.artists.getTopTracks(artistId: id, market: 'de'),
          throwsA(
            isA<SpotifyApiException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.message, 'message', contains('Invalid')),
          ),
        );
      });

      test('unknown artist ID', () {
        final id = '6uFK5OMRw5vqUna1tvbbCG';
        expect(
          api.artists.getTopTracks(artistId: id, market: 'de'),
          throwsA(isA<NotFoundException>()),
        );
      });

      test(
        'unknown market',
        () {
          final artist = artists[0];
          expect(
            api.artists.getTopTracks(artistId: artist.id, market: 'xx'),
            completion(const []),
          );
        },
        skip: 'Spotify will just return a track anyway.',
      );

      for (final spec in artists) {
        if (spec.popularSongIds.isNotEmpty) {
          test(spec.name, () async {
            final future = api.artists.getTopTracks(
              artistId: spec.id,
              market: 'de',
            );
            await expectLater(future, completion(isNotNull));
            final tracks = await future;
            expect(tracks, isNotEmpty);
            final trackIds = tracks.map((e) => e.id).toList();
            for (final track in spec.popularSongIds) {
              expect(trackIds, containsOnce(track));
            }
          });
        }
      }
    });
  });
}
