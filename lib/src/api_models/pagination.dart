import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Page<T> {
  final String href;
  final List<T> items;
  final int limit;
  final int offset;
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
      _$PageFromJson(json, (v) => fromJsonT(v as Map<String, dynamic>));

  factory Page.fromJson(
    Json json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PageFromJson(json, fromJsonT);
}
