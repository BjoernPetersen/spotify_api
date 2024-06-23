import 'dart:async';

import 'package:meta/meta.dart';
import 'package:spotify_api/src/api/api.dart';
import 'package:spotify_api/src/api/core.dart';
import 'package:spotify_api/src/api_models/albums/response.dart';
import 'package:spotify_api/src/api_models/artists/response.dart';
import 'package:spotify_api/src/api_models/model.dart';
import 'package:spotify_api/src/api_models/page.dart';
import 'package:spotify_api/src/api_models/playlists/response.dart';
import 'package:spotify_api/src/api_models/tracks/response.dart';
import 'package:spotify_api/src/exceptions.dart';

sealed class PaginatorImpl {
  PaginatorImpl._();

  static FutureOr<Paginator<T>> fromPage<T>(
    CoreApi core,
    PageRef<T> page,
  ) {
    if (page is Page<T>) {
      return _PaginatorImpl(core, page);
    }
    return _PageRefLoader(core, page).load();
  }
}

final class _PageRefLoader<T> with _PageLoader<T> {
  @override
  final CoreApi core;
  @override
  final FromJson<T> itemFromJson;
  final PageRef<T> page;

  _PageRefLoader(
    this.core,
    this.page,
  ) : itemFromJson = _selectItemFromJson<T>();

  Future<Paginator<T>> load() async {
    final page = await _loadPage(url: this.page.href);
    return _PaginatorImpl(core, page, itemFromJson);
  }
}

@immutable
final class _PaginatorImpl<T> with _PageLoader<T> implements Paginator<T> {
  @override
  final CoreApi core;
  @override
  final Page<T> page;

  @override
  final FromJson<T> itemFromJson;

  _PaginatorImpl(this.core, this.page, [FromJson<T>? itemFromJson])
      : itemFromJson = itemFromJson ?? _selectItemFromJson<T>();

  @override
  List<T> get currentItems => page.items;

  @override
  Future<Paginator<T>?> previousPage() async {
    final previous = page.previous;
    if (previous == null) {
      return null;
    }

    return _PaginatorImpl(
        core,
        await _loadPage(
          url: previous,
        ));
  }

  @override
  Future<Paginator<T>?> nextPage([int? pageSize]) async {
    final next = page.next;
    if (next == null) {
      return null;
    }

    return _PaginatorImpl(
        core,
        await _loadPage(
          url: next,
          pageSize: pageSize,
        ));
  }

  @override
  Stream<T> all([int? pageSize]) async* {
    Page<T> page = this.page;
    while (true) {
      for (final item in page.items) {
        yield item;
      }

      final next = page.next;
      if (next == null) {
        break;
      }

      page = await _loadPage(
        url: next,
        pageSize: pageSize,
      );
    }
  }
}

mixin _PageLoader<T> {
  CoreApi get core;

  FromJson<T> get itemFromJson;

  Page<T> _decodeResponse(Json json) {
    final keys = json.keys.toSet();

    if (keys.length == 1) {
      // assume it's a JSON object with a single key and a Page-value
      final key = keys.first;
      return Page.directFromJson(json[key], itemFromJson);
    }

    const pageKeys = [
      'items',
      'href',
      'total',
      'limit',
      'offset',
    ];

    if (keys.containsAll(pageKeys)) {
      // it's just a direct page
      return Page.directFromJson(json, itemFromJson);
    }

    throw SpotifyApiException('Pagination result is not supported');
  }

  Future<Page<T>> _loadPage({
    required String url,
    int? pageSize,
  }) async {
    final uri = Uri.parse(url);

    final response = await core.client.get(
      uri,
      headers: await core.headers,
      params: {
        if (pageSize != null) 'limit': '$pageSize',
      },
    );

    core.checkErrors(response);

    return response.body.decodeJson(_decodeResponse);
  }
}

FromJson<T> _selectItemFromJson<T>() {
  switch (T) {
    case const (Album):
      return Album.fromJson as FromJson<T>;
    case const (Artist):
      return Artist.fromJson as FromJson<T>;
    case const (Playlist):
      return ((json) => Playlist.fromJson(json)) as FromJson<T>;
    case const (PlaylistTrack):
      return PlaylistTrack.fromJson as FromJson<T>;
    case const (SavedTrack):
      return SavedTrack.fromJson as FromJson<T>;
    case const (Track):
      return Track.fromJson as FromJson<T>;
    default:
      throw UnimplementedError('No Paginator support for $T yet');
  }
}
