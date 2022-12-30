import 'package:json_annotation/json_annotation.dart';
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

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
