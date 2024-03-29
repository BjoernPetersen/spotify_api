@Tags(['integration'])
library;

import 'package:spotify_api/spotify_api.dart';
import 'package:test/test.dart';

import '../integration.dart';

class Track {
  final String id;
  final String name;
  final String artistName;
  final bool isExplicit;
  final bool? isPlayable;

  const Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.isExplicit,
    this.isPlayable,
  });
}

const tracks = [
  Track(
    id: '75n8FqbBeBLW2jUzvjdjXV',
    name: 'Kenning West, Alder',
    artistName: 'Kenning West Records',
    isExplicit: false,
  ),
  Track(
    id: '36q2Psb6FstRqr5EUscdcp',
    name: 'Tausendfrankenlang',
    artistName: 'Faber',
    isExplicit: false,
  ),
  Track(
    id: '5Qt9nyg9UFZJ5iqFsKA4pM',
    name: 'Vivaldi',
    artistName: 'Faber',
    isExplicit: true,
  ),
  Track(
    id: '45Xhva2rBAUnabcYtfZ44n',
    name: 'Berentzen Korn',
    artistName: 'Volker Racho & Andy Theke',
    isExplicit: false,
    isPlayable: false,
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

  group('Tracks', () {
    group('checkUsersSavedTracks', () {
      final savedSongs = const [
        '0G7vexduCvboPyIGjJXQIC',
        '3QN1kcUYlHrtyph4B0nzvz',
        '3lYQM1tw5LAfwnfMMYWWIM',
      ];
      for (final id in savedSongs) {
        test('single song is present $id', () {
          expect(
            api.tracks.checkUsersSavedTracks([id]),
            completion([true]),
          );
        });
      }

      test('batch presence check', () {
        expect(
          api.tracks.checkUsersSavedTracks(savedSongs),
          completion([true, true, true]),
        );
      });

      final unsavedSongs = const [
        '3hOHqkmcLF57wqcFY9HPsj',
        '5y59n0ENwYhZSl62PeUwa5',
      ];

      for (final id in unsavedSongs) {
        test('single song is not present $id', () {
          expect(
            api.tracks.checkUsersSavedTracks([id]),
            completion([false]),
          );
        });
      }

      test('batch absence check', () {
        expect(
          api.tracks.checkUsersSavedTracks(unsavedSongs),
          completion([false, false]),
        );
      });
    });

    group('getTrack', () {
      test('unknown track', () async {
        final track = await api.tracks.getTrack('75n8FqbBeBLW3jUzvjdjXV');
        expect(track, isNull);
      });

      for (final track in tracks) {
        test(track.name, () async {
          final result = await api.tracks.getTrack(
            track.id,
            market: track.isPlayable == null ? null : 'de',
          );
          expect(result, isNotNull);
          result!;
          expect(result.id, track.id);
          expect(result.name, track.name);
          expect(result.isExplicit, track.isExplicit);
          expect(result.artists, hasLength(1));
          expect(result.artists[0].name, track.artistName);
          if (track.isPlayable != null) {
            expect(result.isPlayable, track.isPlayable);
          }
        });
      }
    });

    test('getTracks', () async {
      final trackIds = tracks.map((e) => e.id).toList();
      final results = await api.tracks.getTracks(trackIds);
      expect(results, hasLength(tracks.length));
      expect(results.map((e) => e.id), containsAll(trackIds));
    });

    group('getSavedTracks', () {
      test('get 10', () async {
        final page = await api.tracks.getSavedTracks(limit: 10);
        expect(page.limit, 10);
        expect(page.offset, 0);
        expect(page.next, isNotNull);
        expect(page.items, hasLength(10));
      });

      test('get 100', () async {
        final firstPage = await api.tracks.getSavedTracks(limit: 50);
        final paginator = await api.paginator(firstPage);

        expect(
          paginator.all().take(100).toList(),
          completion(hasLength(100)),
        );
      });
    });

    group('edit saved tracks', () {
      test('save empty IDs', () {
        expect(
          () => api.tracks.saveTracksForCurrentUser([]),
          throwsArgumentError,
        );
      });

      test('remove empty IDs', () {
        expect(
          () => api.tracks.removeUsersSavedTracks([]),
          throwsArgumentError,
        );
      });

      test('happy path', () async {
        final ids = [
          '3hOHqkmcLF57wqcFY9HPsj',
          '5y59n0ENwYhZSl62PeUwa5',
        ];
        await expectLater(api.tracks.saveTracksForCurrentUser(ids), completes);
        await expectLater(api.tracks.removeUsersSavedTracks(ids), completes);
      });
    });

    group('getRecommendations', () {
      for (final limit in [-1, 0, 101]) {
        test('with invalid limit $limit', () {
          expect(
            api.tracks.getRecommendations(
              seeds: TrackRecommendationSeeds(seedTracks: [tracks[0].id]),
              limit: limit,
            ),
            throwsArgumentError,
          );
        });
      }

      group('happy path', () {
        for (final market in [null, 'US']) {
          test('with market "$market"', () async {
            final recommendations = await api.tracks.getRecommendations(
              seeds: TrackRecommendationSeeds(seedTracks: [tracks[0].id]),
              market: market,
            );

            expect(recommendations.seeds, isNotEmpty);
            expect(
              recommendations.seeds.first,
              isA<RecommendationSeedObject>()
                  .having((o) => o.type, 'type', SeedType.track),
            );
            expect(recommendations.tracks, isNotEmpty);
          });
        }
      });
    });
  });
}
