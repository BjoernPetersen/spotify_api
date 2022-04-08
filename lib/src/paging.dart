import 'package:json_annotation/json_annotation.dart';

part 'paging.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Page<T> {
  String href;
  List<T> items;
  int limit;
  int offset;
  int total;
  String previous;
  String next;

  Page({
    required this.href,
    required this.items,
    required this.limit,
    required this.offset,
    required this.total,
    required this.previous,
    required this.next,
  });

  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PageFromJson(json, fromJsonT);
}
