import 'package:spotify_api/spotify_api.dart';

import 'example_utils.dart';

Future<void> main() async {
  final creds = loadCredentials();
  final client = SpotifyWebApi(
    refresher: accessTokenRefresher(creds),
  );

  try {
    // Look up the tracks of an album by the album's ID
    final tracks = await client.playlists.getCurrentUsersPlaylists();
    // We got a page object from Spotify (containing the first tracks,
    // limit and offset). Use a paginator to iterate over all tracks without
    // caring about the pagination details.
    final paginator = await client.paginator(tracks);

    print('First page of playlists:\n${formatPlaylists(paginator.page)}');

    final nextPage = await paginator.nextPage();
    if (nextPage != null) {
      print('\n\nSecond page of playlists:\n${formatPlaylists(nextPage.page)}');
    }
  } finally {
    client.close();
  }
}

String formatPlaylists(Page<Playlist> page) {
  return page.items.map((p) => p.name).join('\n');
}
