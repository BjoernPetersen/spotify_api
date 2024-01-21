import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'response.g.dart';

@immutable
@JsonSerializable(createToJson: false)
final class AvailableGenreSeeds {
  final List<String> genres;

  AvailableGenreSeeds({required this.genres});

  factory AvailableGenreSeeds.fromJson(Map<String, dynamic> json) =>
      _$AvailableGenreSeedsFromJson(json);
}
