import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'page.g.dart';

@immutable
@sealed
@JsonSerializable()
class PageRef<T> {
  final String href;
  final int total;

  PageRef({
    required this.href,
    required this.total,
  });

  factory PageRef.fromJson(Json json, FromJson<T> tFromJson) {
    if (json['items'] != null) {
      return Page.directFromJson(json, tFromJson);
    }

    return _$PageRefFromJson(
      json,
      (json) => tFromJson(json as Json),
    );
  }
}

@immutable
@JsonSerializable()
class Page<T> implements PageRef<T> {
  @override
  final String href;
  final List<T> items;
  final int limit;
  final int offset;
  @override
  final int total;
  final String? previous;
  final String? next;

  Page({
    required this.href,
    required this.items,
    required this.limit,
    required this.offset,
    required this.total,
    required this.previous,
    required this.next,
  });

  factory Page.directFromJson(
    Json json,
    FromJson<T> fromJsonT,
  ) =>
      _$PageFromJson(json, (v) => fromJsonT(v as Json));

  factory Page.fromJson(
    Json json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PageFromJson(json, fromJsonT);
}
