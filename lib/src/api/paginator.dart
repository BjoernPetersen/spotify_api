import 'package:meta/meta.dart';
import 'package:spotify_api/api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:spotify_api/src/api_models/model.dart';

@immutable
class PaginatorImpl<T> implements Paginator<T> {
  final CoreApi core;
  @override
  final Page<T> page;

  final FromJson<T> _itemFromJson;

  PaginatorImpl(this.core, this.page) : _itemFromJson = _selectItemFromJson();

  Future<Page<T>> _loadPage(String url) async {
    final uri = Uri.parse(url);
    final response = await core.client.get(
      uri,
      headers: await core.headers,
    );

    core.checkErrors(response);

    return response.body.decodeJson((json) {
      final keys = json.keys.toList();
      if (keys.length != 1) {
        throw SpotifyApiException('Pagination result is not supported');
      }

      final key = keys[0];

      return Page.directFromJson(
        json[key],
        _itemFromJson,
      );
    });
  }

  @override
  List<T> currentItems() => page.items;

  @override
  Future<Paginator<T>?> previousPage() async {
    final previous = page.previous;
    if (previous == null) {
      return null;
    }

    return PaginatorImpl(core, await _loadPage(previous));
  }

  @override
  Future<Paginator<T>?> nextPage() async {
    final next = page.next;
    if (next == null) {
      return null;
    }

    return PaginatorImpl(core, await _loadPage(next));
  }

  @override
  Stream<T> all() async* {
    Page<T> page = this.page;
    while (true) {
      for (final item in page.items) {
        yield item;
      }

      final next = page.next;
      if (next == null) {
        break;
      }

      page = await _loadPage(next);
    }
  }
}

FromJson<T> _selectItemFromJson<T>() {
  switch (T) {
    case Album:
      return Album.fromJson as FromJson<T>;
    case Artist:
      return Artist.fromJson as FromJson<T>;
    case Track:
      return Track.fromJson as FromJson<T>;
    default:
      throw UnimplementedError('No Paginator support for $T yet');
  }
}
