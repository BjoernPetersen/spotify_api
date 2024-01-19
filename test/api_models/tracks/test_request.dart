import 'package:spotify_api/spotify_api.dart';
import 'package:test/test.dart';

void main() {
  group('TrackRecommendationConstraints', () {
    test('all null', () {
      expect(TrackRecommendationConstraints().toQueryParameters(), isEmpty);
    });
    test('all filled', () {
      final uut = TrackRecommendationConstraints(
        acousticness: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        danceability: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        duration: AttributeConstraints(
          min: Duration.zero,
          max: const Duration(days: 1),
          target: const Duration(minutes: 3),
        ),
        energy: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        instrumentalness: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        key: AttributeConstraints(
          min: 0,
          max: 1,
          target: 1,
        ),
        liveness: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        loudness: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        mode: AttributeConstraints(
          min: 0,
          max: 1,
          target: 0,
        ),
        popularity: AttributeConstraints(
          min: 0.0,
          max: 100,
          target: 50,
        ),
        speechiness: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        tempo: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
        timeSignature: AttributeConstraints(
          min: 0,
          max: 1,
          target: 0,
        ),
        valence: AttributeConstraints(
          min: 0.0,
          max: 1.0,
          target: 0.5,
        ),
      );

      final queryParams = uut.toQueryParameters();
      expect(queryParams, hasLength(42));
      expect(
        queryParams.keys,
        isNot(
          anyElement(predicate(
            (key) => (key as String).toLowerCase() != key,
            'contains upper case letter',
          )),
        ),
      );
    });
  });
  group('AttributeConstraints', () {
    late Map<String, String> map;

    setUp(() {
      map = {};
    });

    test('double', () {
      final uut = AttributeConstraints(
        min: 1.5,
        max: 3.5,
        target: 2.5,
      );
      uut.addToQueryParams(map, 'test');
      expect(
        map,
        {
          'min_test': '1.5',
          'max_test': '3.5',
          'target_test': '2.5',
        },
      );
    });
    test('int', () {
      final uut = AttributeConstraints(
        min: 1,
        max: 50,
        target: 25,
      );
      uut.addToQueryParams(map, 'test');
      expect(
        map,
        {
          'min_test': '1',
          'max_test': '50',
          'target_test': '25',
        },
      );
    });
    test('Duration', () {
      final uut = AttributeConstraints(
        min: Duration.zero,
        max: Duration(seconds: 10),
        target: Duration(seconds: 5),
      );
      uut.addToQueryParams(map, 'test');
      expect(
        map,
        {
          'min_test': '0',
          'max_test': '10000',
          'target_test': '5000',
        },
      );
    });
  });

  group('TrackRecommendationSeeds', () {
    test('no seeds', () {
      expect(
        () => TrackRecommendationSeeds(),
        throwsArgumentError,
      );
    });

    test('too many seeds', () {
      expect(
        () => TrackRecommendationSeeds(
          seedArtists: ['abc'],
          seedGenres: ['def', 'ghi'],
          seedTracks: ['123', '345', '678'],
        ),
        throwsArgumentError,
      );
    });
    test('one seed', () {
      expect(
        () => TrackRecommendationSeeds(
          seedGenres: ['def'],
        ),
        returnsNormally,
      );
    });
    test('five seeds', () {
      expect(
        () => TrackRecommendationSeeds(
          seedArtists: ['abc'],
          seedGenres: ['def', 'ghi'],
          seedTracks: [
            '123',
            '345',
          ],
        ),
        returnsNormally,
      );
    });
  });
}
