import 'package:spotify_api/spotify_api.dart';

import 'example_utils.dart';

Future<void> main() async {
  final creds = loadCredentials();
  final client = SpotifyWebApi(
    refresher: ClientCredentialsRefresher(
      clientId: creds.clientId,
      clientSecret: creds.clientSecret!,
    ),
  );

  try {
    // Look up the tracks of an album by the album's ID
    final tracks = await client.albums.getAlbumTracks('6Q1fxM7xBU5K2J1zo0usMz');
    if (tracks == null) {
      print('Album not found');
    } else {
      print('Found tracks:');
      // We got a page object from Spotify (containing the first tracks,
      // limit and offset). Use a paginator to iterate over all tracks without
      // caring about the pagination details.
      final paginator = await client.paginator(tracks);
      await paginator.all().forEach((track) {
        print(track.name);
      });
    }
  } finally {
    client.close();
  }
}
