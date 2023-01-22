@Tags(['integration'])
import 'package:spotify_api/api.dart';
import 'package:test/test.dart';

import '../integration.dart';

class Track {
  final String id;
  final String name;
  final String artistName;
  final bool isExplicit;
  final String? market;
  final bool? isPlayable;

  const Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.isExplicit,
    this.market,
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
    market: 'de',
    isPlayable: false,
  ),
];

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  group('Tracks', () {
    group('getTrack', () {
      for (final track in tracks) {
        test(track.name, () async {
          final result = await api.tracks.getTrack(
            track.id,
            market: track.market,
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
  });
}
