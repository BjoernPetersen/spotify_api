import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:meta/meta.dart';

part 'image.g.dart';

@immutable
@JsonSerializable()
class Image {
  final int height;
  final String url;
  final int width;

  Image({
    required this.height,
    required this.url,
    required this.width,
  });

  factory Image.fromJson(Json json) => _$ImageFromJson(json);
}
