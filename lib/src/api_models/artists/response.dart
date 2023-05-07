import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'response.g.dart';

@immutable
@JsonSerializable(createToJson: false)
class Artist {
  final String id;
  final String name;

  /// The popularity of the artist.
  ///
  /// The value will be between 0 and 100, with 100 being the most popular.
  ///
  /// The artist's popularity is calculated from the popularity of all the
  /// artist's tracks.
  final int? popularity;

  Artist({
    required this.id,
    required this.name,
    required this.popularity,
  });

  factory Artist.fromJson(Json json) => _$ArtistFromJson(json);
}

@immutable
@JsonSerializable(createToJson: false)
class Artists {
  final List<Artist?> artists;

  Artists(this.artists);

  factory Artists.fromJson(Json json) => _$ArtistsFromJson(json);
}
