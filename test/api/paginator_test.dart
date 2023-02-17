@Tags(['integration'])
import 'package:spotify_api/spotify_api.dart';
import 'package:test/test.dart';

import '../integration.dart';

void main() {
  late SpotifyWebApi api;

  setUpAll(() async {
    api = await loadApi();
  });

  tearDownAll(() {
    api.close();
  });

  group('search for love songs', () {
    late Paginator<Track> paginator;

    setUpAll(() async {
      final result = await api.search(query: 'love', types: [SearchType.track]);
      final firstPage = result.tracks;
      expect(firstPage, isNotNull);
      firstPage!;
      paginator = await api.paginator(firstPage);
    });

    test('get current items', () {
      expect(paginator.currentItems, paginator.page.items);
    });

    test('get non-existent previous', () {
      expect(paginator.previousPage(), completion(isNull));
    });

    test('get next page', () async {
      final Paginator<Track>? nextPage = await paginator.nextPage();
      expect(nextPage, isNotNull);
      nextPage!;
      expect(nextPage.page.offset, isPositive);
      expect(nextPage.page.items, hasLength(paginator.page.limit));
    });

    test('get previous page of next page', () async {
      final nextPage = await paginator.nextPage();
      nextPage!;
      final previousPage = await nextPage.previousPage();
      expect(previousPage?.page, paginator.page);
    });

    test('get next page with higher limit', () async {
      final Paginator<Track>? nextPage = await paginator.nextPage(21);
      expect(nextPage, isNotNull);
      nextPage!;
      expect(nextPage.page.offset, isPositive);
      expect(nextPage.page.items, hasLength(21));
    });

    test('get 200 tracks', () async {
      final tracks = await paginator.all(50).take(200).toList();
      expect(tracks, hasLength(200));
      expect(tracks.toSet(), hasLength(tracks.length));
    });
  });
}
