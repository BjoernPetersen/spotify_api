import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:meta/meta.dart';

part 'image.g.dart';

@immutable
@JsonSerializable(createToJson: false)
class Image {
  /// The image height in pixels.
  @JsonKey(fromJson: parseOptionalNumAsInt)
  final int? height;

  /// The source URL of the image.
  final String url;

  /// The image width in pixels.
  @JsonKey(fromJson: parseOptionalNumAsInt)
  final int? width;

  Image({
    required this.height,
    required this.url,
    required this.width,
  });

  factory Image.fromJson(Json json) => _$ImageFromJson(json);
}
