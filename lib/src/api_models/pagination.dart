import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_api/src/api_models/model.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Page<T> {
  String href;
  List<T> items;
  int limit;
  int offset;
  int total;
  String? previous;
  String? next;

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
    Map<String, dynamic> json,
    FromJson<T> fromJsonT,
  ) =>
      _$PageFromJson(json, (v) => fromJsonT(v as Map<String, dynamic>));

  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PageFromJson(json, fromJsonT);
}
