@Tags(['integration'])
import 'package:spotify_api/api.dart';
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
  });
}
