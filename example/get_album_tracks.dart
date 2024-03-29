import 'package:spotify_api/spotify_api.dart';

import 'example_utils.dart';

Future<void> main() async {
  final creds = loadCreds();
  final client = SpotifyWebApi(
    refresher: accessTokenRefresher(creds),
  );

  try {
    final tracks = await client.albums.getAlbumTracks('6Q1fxM7xBU5K2J1zo0usMz');
    if (tracks == null) {
      print('Album not found');
    } else {
      print('Found tracks:');
      final paginator = await client.paginator(tracks);
      await paginator.all().forEach((track) {
        print(track.name);
      });
    }
  } finally {
    client.close();
  }
}
