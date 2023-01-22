import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'response.g.dart';

@immutable
@JsonSerializable()
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

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
