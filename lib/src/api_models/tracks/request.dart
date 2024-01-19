import 'package:meta/meta.dart';

@immutable
final class TrackRecommendationSeeds {
  final List<String> seedArtists;
  final List<String> seedGenres;
  final List<String> seedTracks;

  TrackRecommendationSeeds._({
    required this.seedArtists,
    required this.seedGenres,
    required this.seedTracks,
  });

  /// Seeds for track recommendations from Spotify. Up to 5 seeds values may be provided in any
  /// combination of the three parameters. At least one value must be provided.
  factory TrackRecommendationSeeds({
    /// A comma separated list of
    /// [Spotify IDs](https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids).
    List<String> seedArtists = const [],

    /// A comma separated list of any genres in the set of available genre seeds.
    List<String> seedGenres = const [],

    /// A comma separated list of
    /// [Spotify IDs](https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids).
    List<String> seedTracks = const [],
  }) {
    final count = seedArtists.length + seedGenres.length + seedTracks.length;
    if (count == 0) {
      throw ArgumentError('At least one seed parameter must be non-empty');
    } else if (count > 5) {
      throw ArgumentError('More than 5 seed values are not allowed');
    }

    return TrackRecommendationSeeds._(
      seedArtists: seedArtists,
      seedGenres: seedGenres,
      seedTracks: seedTracks,
    );
  }

  Map<String, String> toQueryParameters() {
    return {
      if (seedArtists.isNotEmpty) 'seed_artists': seedArtists.join(','),
      if (seedGenres.isNotEmpty) 'seed_genres': seedGenres.join(','),
      if (seedTracks.isNotEmpty) 'seed_tracks': seedTracks.join(','),
    };
  }
}

@immutable
final class AttributeConstraints<T> {
  final T? min;
  final T? max;
  final T? target;

  const AttributeConstraints({
    this.min,
    this.max,
    this.target,
  });

  void addToQueryParams(Map<String, String> map, String name) {
    final String Function(T) toString;
    if (T == Duration) {
      toString =
          ((Duration d) => d.inMilliseconds.toString()) as String Function(T);
    } else {
      toString = (T value) => value.toString();
    }

    final min = this.min;
    if (min != null) {
      map['min_$name'] = toString(min);
    }

    final max = this.max;
    if (max != null) {
      map['max_$name'] = toString(max);
    }

    final target = this.target;
    if (target != null) {
      map['target_$name'] = toString(target);
    }
  }
}

@immutable
final class TrackRecommendationConstraints {
  final AttributeConstraints<double>? acousticness;
  final AttributeConstraints<double>? danceability;
  final AttributeConstraints<Duration>? duration;
  final AttributeConstraints<double>? energy;
  final AttributeConstraints<double>? instrumentalness;
  final AttributeConstraints<int>? key;
  final AttributeConstraints<double>? liveness;
  final AttributeConstraints<double>? loudness;
  final AttributeConstraints<int>? mode;
  final AttributeConstraints<double>? popularity;
  final AttributeConstraints<double>? speechiness;
  final AttributeConstraints<double>? tempo;
  final AttributeConstraints<int>? timeSignature;
  final AttributeConstraints<double>? valence;

  const TrackRecommendationConstraints({
    this.acousticness,
    this.danceability,
    this.duration,
    this.energy,
    this.instrumentalness,
    this.key,
    this.liveness,
    this.loudness,
    this.mode,
    this.popularity,
    this.speechiness,
    this.tempo,
    this.timeSignature,
    this.valence,
  });

  Map<String, String> toQueryParameters() {
    final result = <String, String>{};

    acousticness?.addToQueryParams(result, 'acousticness');
    danceability?.addToQueryParams(result, 'danceability');
    duration?.addToQueryParams(result, 'duration');
    energy?.addToQueryParams(result, 'energy');
    instrumentalness?.addToQueryParams(result, 'instrumentalness');
    key?.addToQueryParams(result, 'key');
    liveness?.addToQueryParams(result, 'liveness');
    loudness?.addToQueryParams(result, 'loudness');
    mode?.addToQueryParams(result, 'mode');
    popularity?.addToQueryParams(result, 'popularity');
    speechiness?.addToQueryParams(result, 'speechiness');
    tempo?.addToQueryParams(result, 'tempo');
    timeSignature?.addToQueryParams(result, 'time_signature');
    valence?.addToQueryParams(result, 'valence');

    return result;
  }
}
